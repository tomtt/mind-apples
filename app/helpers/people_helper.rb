module PeopleHelper
  def picture_missing?(image_url)
    return true if image_url.include? "missing.png"
    false
  end
end
