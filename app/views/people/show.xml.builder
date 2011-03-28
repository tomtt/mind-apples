xml.person do
  xml.login h(@person.login)
  xml.name h(@person.name)
  xml.avatar_url(image_path(@person.avatar.url))
end
