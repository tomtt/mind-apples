require "aws/s3"

class PeopleImport < ActiveRecord::Base
  BUCKET = "mindapples-people_imports"
  TOP_LEVEL_DIRECTORY = Rails.env

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
