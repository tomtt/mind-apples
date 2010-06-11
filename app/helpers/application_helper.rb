# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def page_title
    elements = ["Mindapples"]
    elements << @page_title if @page_title
    elements.join(' - ')
  end

  def show_flashes
    return '' unless flash.length > 0
    output = "<div id=\"flashes\" style=\"display:inherit;\">\n"
    flash.each do |key, value|
      output += content_tag('div', value.to_s, :class => "flash_#{key.to_s}")
    end
    output += "</div>\n"
    output
  end

  def logged_in_info
    if current_user
      link_to('Your mindapples page', person_path(current_user)) +
        if current_user.login_set_by_user?
          " | Welcome back '%s' | " % current_user.to_s
        else
          " | Welcome back | "
        end +
        link_to('Log out', logout_path)
    else
      "Already taken the test? " +
      link_to('Log in to claim your page', login_path)
    end
  end

  def page_possessor(person)
    if person.name_for_view
      h(person.name_for_view) + "'s"
    else
      if current_user == person
        'Your'
      else
        "Somebody's"
      end
    end
  end

  def dev_info
    if RAILS_ENV == 'development'
      '<div class="logged-in-debug">' + logged_in_info + '</div>'
    else
      ''
    end
  end

  def git_info
    '<div class="git-version">version: ' + Git.master_head_sha1 + '</div>'
  end
    
  def share_this_icons
    # genereted at http://www.addthis.com/

    '<!-- AddThis Button BEGIN -->
    
      <div id="share_this_links" class="addthis_toolbox addthis_default_style">
        <a class="addthis_button_facebook" addthis:url="http://mindapples.staging.tomtenthij.co.uk/"></a>
        <a class="addthis_button_twitter" addthis:url="http://mindapples.staging.tomtenthij.co.uk/"></a>
      </div>
      
      <script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#username=xa-4c1213380f6109b1">
        show_share_this_icons();
      </script>
      
    <!-- AddThis Button END -->'    
  end
end
