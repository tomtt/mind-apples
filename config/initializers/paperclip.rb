if Rails.env.production?
  Paperclip::Attachment.default_options[:storage] = :s3
  Paperclip::Attachment.default_options[:bucket]  = ENV['S3_BUCKET']
  Paperclip::Attachment.default_options[:s3_credentials] = {
    :access_key_id     => ENV['S3_KEY'],
    :secret_access_key => ENV['S3_SECRET']
  }
end
