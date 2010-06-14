module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /^the homepage$/
      '/'
    when /^the login page$/
      login_path
    when /^the logout page$/
      logout_path
    when /^the "take the test" page$/
      new_person_path
    when /^the full form page$/
      '/people/new'      
    when /^the "about" page$/
      about_path
    when /^the "fives" page$/
      fives_path
    when /^the "help us grow" page$/
      help_us_grow_path
    when /^the "links" page$/
      links_path
    when /^the url "this-is-a-page-that-blows-up-to-test-the-500-error"$/
      'this-is-a-page-that-blows-up-to-test-the-500-error'
    when /^my mindapples page$/
      person_path(@me_person)
    when /^my edit page$/
      edit_person_path(@me_person)
    when /^full form edit page$/
      '/person'     
    when /^my favourite mindapples page$/   
      "/person/#{@me_person.login}/favourites"
    when /^"(.*)\" edit page$/
      person = Person.find_by_login($1)
      edit_person_path(person)
      
    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      page_name =~ /^\"(.*)\"$/
      begin
        if ActionController::Routing::Routes::recognize_path $1, :method => :get
          $1
        end
      rescue ActionController::RoutingError, TypeError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
