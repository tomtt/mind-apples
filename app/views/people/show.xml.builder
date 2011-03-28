xml.person do
  xml.login h(@person.login)
  xml.name h(@person.name)
  if @person.avatar?
    xml.avatar_url(image_path(@person.avatar.url))
  end
end
