require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include PeopleHelper

describe PeopleHelper do
  
  it "populated unsaved resource object with data from params" do
    resource = Person.new
    params[:person] = {:email => 'mind@apples.com',
                       :login => 'calm_mind',
                       :some_value => 'artifical'}

    populate_resource(resource)

    resource.email.should == 'mind@apples.com'
    resource.login.should == 'calm_mind'
    resource.some_value.should == 'artifical'
  end

end
