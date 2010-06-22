module UserSessionsHelper
  def error_messages(messages)
    return messages unless messages.include? "Login/Password combination is not valid"
    "<div class=\"errorExplanation\" id=\"errorExplanation\"><h2>Sorry, we don't recognise that username and password combination. Please try again.</h2></div>"
  end
end
