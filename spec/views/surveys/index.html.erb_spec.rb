require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/surveys/index.html.erb" do
  include SurveysHelper
  
  before(:each) do
    assigns[:surveys] = [
      stub_model(Survey,
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
      ),
      stub_model(Survey,
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
    ]
  end

  it "should render list of surveys" do
    render "/surveys/index.html.erb"
    response.should have_tag("tr>td", "value for apple_1", 2)
    response.should have_tag("tr>td", "value for apple_2", 2)
    response.should have_tag("tr>td", "value for apple_3", 2)
    response.should have_tag("tr>td", "value for apple_4", 2)
    response.should have_tag("tr>td", "value for apple_5", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "value for famous_fives", 2)
    response.should have_tag("tr>td", "value for age_range", 2)
    response.should have_tag("tr>td", "value for country", 2)
    response.should have_tag("tr>td", "value for name", 2)
    response.should have_tag("tr>td", "value for email", 2)
  end
end

