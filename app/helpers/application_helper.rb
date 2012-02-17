# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def page_title
    elements = ["Mindapples"]
    elements << @page_title if @page_title
    elements.join(' - ')
  end

  def show_flashes
    return '' unless flash.length > 0
    output = %Q[<div id="flashes" style="display:inherit;">\n]
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

  def share_this_icons
    # CGI.escape has a habit of replacing spaces with plus signs, so we manually convert them to %20 entities
    text        = CGI.escape("What's the 5-a-day for your mind? Time to share your #mindapples!").gsub("+", "%20")
    url         = CGI.escape(request.url)
    twitter_url = "http://twitter.com/share?url=#{url}&text=#{text}"
    
    twitter_button  = link_to("Tweet these mindapples", twitter_url, :class => "twitter-share-button")
    fb_button       = "<div id='fb-root'></div><script src='http://connect.facebook.net/en_US/all.js#xfbml=1'></script><fb:like href='#{url}'; send='false' layout='button_count' width='450' show_faces='false' font=''></fb:like>"
    
    share_this = content_tag :div, :class => "aside share" do
      content_tag( :h3, "Share this" ) +
      content_tag(:div, :class => "inner") do
        content_tag( :div, :class => "twitter") do
          twitter_button
        end +
        content_tag( :div, :class => "facebook") do
          fb_button
        end
      end
    end
  end

  def share_url
    return "#{root_url}person/#{current_user.login}"
  end
  
  def share_this_icons_large
    '<a href="http://api.addthis.com/oexchange/0.8/forward/facebook/offer?url='+share_url+'" id="addthis_button_facebook"  target="_blank"><img src="/images/icons/facebook_large.png" alt="facebook" /></a>
    <a href="http://twitter.com/home?status=I%27ve+just+shared+my+Mindapples+5-a-day.+What+five+things+do+YOU+do+to+look+after+your+mind%3F+'+share_url+'" id="addthis_button_twitter" target="_blank"><img src="/images/icons/twitter_large.png" alt="twitter" /></a>'
  end

  def header_error_message(errors_count)
    return "Oh dear, there were #{errors_count} problems:" if errors_count > 1
    "Oh dear, there was a problem:"
  end
  
  def set_focus_to_id(id)
    javascript_tag("$().ready(function(){ $('##{id}').focus() });");
  end

  def facebook_like_box
    %q[<iframe src="http://www.facebook.com/plugins/likebox.php?href=http%3A%2F%2Fwww.facebook.com%2Fmindapples&amp;width=400&amp;colorscheme=light&amp;show_faces=true&amp;border_color=%23d0d0d0&amp;stream=false&amp;header=false&amp;height=258" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:400px; height:258px;" allowTransparency="true"></iframe>]
  end

  def twitter_feed_box
    render "shared/twitter_feed"
  end
end
