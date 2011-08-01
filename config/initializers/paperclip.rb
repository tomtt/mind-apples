if Rails.env.production? || Rails.env.staging? || ENV['S3_ENABLED'] == "TRUE"
  Paperclip::Attachment.default_options[:storage] = :s3
  Paperclip::Attachment.default_options[:bucket] = ENV['S3_BUCKET']
  Paperclip::Attachment.default_options[:s3_credentials] = {
    :access_key_id => ENV['S3_KEY'],
    :secret_access_key => ENV['S3_SECRET']
  }
  
  # Save attachments under an environment-specific directory to
  # avoid uploading to the same paths as production
  path = Rails.env.production? ? "" : "#{Rails.env}/"
  path += ":attachment/:id/:style.:extension"
  Paperclip::Attachment.default_options[:path] = path
end
