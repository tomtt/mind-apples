class PersonMailer < ActionMailer::Base

  def welcome_email(person)
    subject    'Your Mindapples'
    recipients person.email
    from       ''
    body       :greeting => 'Hi,',
               :mindapples => person.mindapples,
               :personal_page_url => person_url(person, :host => Mindapples::Config['host'])
  end

  def set_password(person)
    subject    'Setting your Mindapples password'
    recipients person.email
    from       ''

    body       :edit_password_reset_url => edit_password_reset_url(person.perishable_token)
  end

end
