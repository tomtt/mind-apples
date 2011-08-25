module PeopleHelper

  def populate_resource(person_resource)
    params[:person].each do |key, value| 
      person_resource[key.to_sym] = value unless value.blank? && key == 'login'
    end
  end

  def person_link(mindapple)
    if mindapple.person.login_set_by_user? && ( mindapple.person.public_profile == true || match_logger_user?( mindapple.person))
      name = mindapple.person.name || mindapple.person.login
      link_to name, person_path(mindapple.person)
    elsif mindapple.person.name.blank? || mindapple.person.public_profile == false
      "anonymous"
    else
      mindapple.person.name
    end
  end

  def match_logger_user?(person)
    current_user.id == person.id if current_user
  end

  def suggestion(position)
    return '' unless session[:suggestions][position.to_s]
    person_suggestion = session[:suggestions][position.to_s]["suggestion"]
    session[:suggestions] = nil if position == 4
    person_suggestion
  end

end
