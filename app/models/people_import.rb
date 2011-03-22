# == Schema Information
#
# Table name: people_imports
#
#  id                    :integer         not null, primary key
#  s3_etag               :text
#  s3_key                :text
#  user_type_description :text
#  network_id            :integer
#  created_at            :datetime
#  updated_at            :datetime
#

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
      @results << Person.create_from_keys_and_values(keys,
                                                     values,
                                                     :network => network,
                                                     :type_description => user_type_description,
                                                     :import_s3_etag => s3_object.etag)
    end
    @results
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
