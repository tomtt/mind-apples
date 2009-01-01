require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/surveys/show.html.erb" do
  include SurveysHelper
  
  before(:each) do
    assigns[:survey] = @survey = stub_model(Survey,
      :apple_1 => "value for apple_1",
      :apple_2 => "value for apple_2",
      :apple_3 => "value for apple_3",
      :apple_4 => "value for apple_4",
      :apple_5 => "value for apple_5",
      :health_check => "1",
      :famous_fives => "value for famous_fives",
      :age_range => "value for age_range",
      :country => "value for country",
      :name => "value for name",
      :email => "value for email"
    )
  end

  it "should render attributes in <p>" do
    render "/surveys/show.html.erb"
    response.should have_text(/value\ for\ apple_1/)
    response.should have_text(/value\ for\ apple_2/)
    response.should have_text(/value\ for\ apple_3/)
    response.should have_text(/value\ for\ apple_4/)
    response.should have_text(/value\ for\ apple_5/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ famous_fives/)
    response.should have_text(/value\ for\ age_range/)
    response.should have_text(/value\ for\ country/)
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ email/)
  end
end

