class PersonMailer < ActionMailer::Base

  def mindapples(sent_at = Time.now)
    subject    'Your Mindapples'
    recipients ''
    from       ''
    sent_on    sent_at

    body       :greeting => 'Hi,'
  end

  def set_password(sent_at = Time.now)
    subject    'Setting your Mindapples password'
    recipients ''
    from       ''
    sent_on    sent_at

    body       :greeting => 'Hi,'
  end

end
