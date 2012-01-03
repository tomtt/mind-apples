module PeopleHelper

  def populate_resource(person_resource)
    params[:person].each do |key, value| 
      person_resource[key.to_sym] = value unless value.blank? && key == 'login'
    end
  end

  def person_link(mindapple)
    person = mindapple.person
    if ! person.anonymous? and (person.public_profile or current_user_owns_person?(person))
      name = person.name || person.user.login
      link_to name, person_path(person)
    elsif person.public_profile and person.name.present?
      person.name
    else
      "anonymous"
    end
  end

  def current_user_owns_person?(person)
    !! current_user and person.user == current_user
  end

  def suggestion(position)
    return '' unless session[:suggestions][position.to_s]
    person_suggestion = session[:suggestions][position.to_s]["suggestion"]
    session[:suggestions] = nil if position == 4
    person_suggestion
  end

end
