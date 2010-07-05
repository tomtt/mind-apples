module PeopleHelper
  
  def populate_resource(person_resource)
    params[:person].each do |key, value|
      person_resource[key.to_sym] = value
    end
  end
  
  def person_link(mindapple)
    return "anonymous" unless mindapple.person.login_set_by_user?
    link_to (mindapple.person.name || mindapple.person.login), person_path(mindapple.person)
  end
  
  def suggestion(position)
    return '' unless session[:suggestions][position.to_s]
    person_suggestion = session[:suggestions][position.to_s]["suggestion"]
    session[:suggestions] = nil if position == 4
    person_suggestion
  end

end
