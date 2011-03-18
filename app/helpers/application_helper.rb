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
    '<a href="http://twitter.com/home?status=I%27ve+just+shared+my+Mindapples+5-a-day.+What+five+things+do+YOU+do+to+look+after+your+mind%3F+http%3A%2F%2Fbit.ly%2Fc5Ylta" id="addthis_button_twitter" target="_blank"><img src="/images/icons/twitter.png" alt="twitter" /></a>
     <a href="http://api.addthis.com/oexchange/0.8/forward/facebook/offer?url='+root_url+'" id="addthis_button_facebook"  target="_blank"><img src="/images/icons/facebook.png" alt="facebook" /></a>'
  end

  def header_error_message(errors_count)
    return "Oh dear, there were #{errors_count} problems:" if errors_count > 1
    "Oh dear, there was a problem:"
  end

  def network_form_header
    if @network && @network.form_header && ! (@network.form_header.empty?)
      "<p class='network_header'>#{@network.form_header}</p>\n"
    end
  end
end
