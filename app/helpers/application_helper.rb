# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def show_flashes
    return '' unless flash.length > 0
    output = "<div id=\"flashes\" style=\"display:inherit;\">\n"
    flash.each do |key, value|
      output += content_tag('div', value.to_s, :class => "flash_#{key.to_s}")
    end
    output += "</div>\n"
    output
  end

  def when_logged_in(&block)
    if logged_in?
      concat(capture(&block), block.binding)
    end
  end

  def when_not_logged_in(&block)
    unless logged_in?
      concat(capture(&block), block.binding)
    end
  end
end
