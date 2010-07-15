class PersonMailer < ActionMailer::Base
  SENDER_EMAIL = ''

  def welcome_email(person)
    subject    'Your Mindapples'
    recipients person.email
    from       SENDER_EMAIL
    body       :greeting => 'Hi,',
               :mindapples => person.mindapples,
               :personal_page_url => person_url(person, :host => Mindapples::Config['host'])
  end

  def claim_your_page(person)
    subject 'Claim your page on the new Mindapples website!'
    recipients person.email
    from       SENDER_EMAIL
    body       :claim_your_page_url => edit_person_url(person, :user_credentials => person.single_access_token, :host => Mindapples::Config['host'])
  end

  def set_password(person)
    subject    'Setting your Mindapples password'
    recipients person.email
    from       SENDER_EMAIL
    
    body       :edit_password_reset_url => edit_password_reset_url(person.perishable_token, :host => Mindapples::Config['host'])
  end
end
