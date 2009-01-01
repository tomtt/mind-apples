require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/surveys/edit.html.erb" do
  include SurveysHelper
  
  before(:each) do
    assigns[:survey] = @survey = stub_model(Survey,
      :new_record? => false,
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

  it "should render edit form" do
    render "/surveys/edit.html.erb"
    
    response.should have_tag("form[action=#{survey_path(@survey)}][method=post]") do
      with_tag('textarea#survey_apple_1[name=?]', "survey[apple_1]")
      with_tag('textarea#survey_apple_2[name=?]', "survey[apple_2]")
      with_tag('textarea#survey_apple_3[name=?]', "survey[apple_3]")
      with_tag('textarea#survey_apple_4[name=?]', "survey[apple_4]")
      with_tag('textarea#survey_apple_5[name=?]', "survey[apple_5]")
      with_tag('input#survey_health_check[name=?]', "survey[health_check]")
      with_tag('textarea#survey_famous_fives[name=?]', "survey[famous_fives]")
      with_tag('input#survey_age_range[name=?]', "survey[age_range]")
      with_tag('input#survey_country[name=?]', "survey[country]")
      with_tag('input#survey_name[name=?]', "survey[name]")
      with_tag('input#survey_email[name=?]', "survey[email]")
    end
  end
end


