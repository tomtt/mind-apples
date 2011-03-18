require "aws/s3"
require "fastercsv"

class PeopleImport < ActiveRecord::Base
  BUCKET = "mindapples-people_imports"
  TOP_LEVEL_DIRECTORY = Rails.env

  before_save :perform_csv_import
  attr_reader :results

  belongs_to :network

  def perform_csv_import
    s3_object = PeopleImport.find_csv_by_s3_key(s3_key)
    csv_content = s3_object.value
    data = []

    FasterCSV.parse(csv_content) do |row|
      data << row
    end

    keys = data.shift

    @results = []

    data.each do |values|
      begin
        attributes = ModelAttributes.construct(keys, values)
        password = PageCode.code(20)
        attributes["password"] = password
        attributes["password_confirmation"] = password

        begin
          person = Person.new(attributes)
          page_code = PageCode.code
          person.page_code = page_code
          person.login = '%s%s' % [Person::AUTOGEN_LOGIN_PREFIX, page_code]
          person.network = network
          person.type_description = user_type_description
          person.import_s3_etag = s3_object.etag
          person.save!
          @results << person
        rescue => e
          @results << "#{attributes['email']} (#{attributes['name']}): Error: #{e.to_s}"
        end
      rescue => e
        @results << "Parse error: #{e.to_s}"
      end
    end
  end

  module S3ObjectHelpers
    def displayed_filename
      key.sub(/^#{TOP_LEVEL_DIRECTORY}\//, "")
    end

    def last_modified
      DateTime.parse(about["last-modified"])
    end
  end

  def self.s3_csv_objects
    establish_s3_connection!
    objects = AWS::S3::Bucket.objects(BUCKET)
    objects.select { |o| o.key =~ %r|^#{TOP_LEVEL_DIRECTORY}/.*\.csv$|i }
  end

  def self.s3_csv_directory
    establish_s3_connection!
    AWS::S3::Bucket.objects(BUCKET).select { |o| o.key == "#{TOP_LEVEL_DIRECTORY}/" }.first
  end

  def self.find_csv_by_s3_key(key)
    establish_s3_connection!
    AWS::S3::S3Object.find(key, BUCKET)
  end

  private

  def self.establish_s3_connection!
    AWS::S3::Base.establish_connection!(:access_key_id => ENV["S3_KEY"], :secret_access_key => ENV["S3_SECRET"])
  end
end

module AWS
  module S3
    class S3Object
      include PeopleImport::S3ObjectHelpers
    end
  end
end
