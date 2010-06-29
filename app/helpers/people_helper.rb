module PeopleHelper
  
  def populate_resource(person_resource)
    params[:person].each do |key, value|
      person_resource[key.to_sym] = value
    end
  end
end
