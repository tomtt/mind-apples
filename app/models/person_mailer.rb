class PersonMailer < ActionMailer::Base

  def welcome_email(person)
    subject    'Your Mindapples'
    recipients person.email
    from       ''
    body       :greeting => 'Hi,',
               :mindapples => person.mindapples
  end

  def set_password(email, name, sent_at = Time.now)
    subject    'Setting your Mindapples password'
    recipients ''
    from       ''
    sent_on    sent_at

    body       :greeting => 'Hi,'
  end

end