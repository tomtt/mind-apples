require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PersonMailer do
  CHARSET = 'utf-8'

  include ActionMailer::Quoting

  before do
    @expected = TMail::Mail.new
    @expected.set_content_type 'text', 'plain', { 'charset' => CHARSET }
    @expected.mime_version = '1.0'
  end

  describe "mindapples email" do
    before do
      @person = Factory.create(:person, :email => 'test@example.com')
    end

    it "should have 'Your Mindapples' in the subject" do
      mail = PersonMailer.deliver_welcome_email(@person)
      mail.subject.should == "Your Mindapples"
    end

    it "should be sent to the person's email address" do
      mail = PersonMailer.deliver_welcome_email(@person)
      mail.should deliver_to('test@example.com')
    end

    it "should contain the person's mindapples" do
      @person.mindapples << Factory.create(:mindapple, :suggestion => "eat apples")
      @person.mindapples << Factory.create(:mindapple, :suggestion => "drink chocolate milk")
      mail = PersonMailer.deliver_welcome_email(@person)
      mail.body.should include("eat apples")
      mail.body.should include("drink chocolate milk")
    end

    it "should contain a link to the person's personal page, including the host" do
      mail = PersonMailer.deliver_welcome_email(@person)
      # ActionController::UrlWriter.person_url seems to not be accessible
      mail.body.should include("http://#{Mindapples::Config['host']}/person/#{@person.to_param}")
    end
  end
end
