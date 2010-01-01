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
end
