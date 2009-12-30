module MiscHelpers
  def xpath_search(xpath)
    @_webrat_session.dom.xpath(xpath)
  end

  def parse_date_time(date_string)
    if date_string =~ /^(\d+)\s*(\S+)\s+(ago|from_now)$/
      # '3 days ago' => 3.days.ago
      $1.to_i.send($2.to_sym).send($3.to_sym)
    elsif date_string =~ /^([+-])\s*(\d+)\s*(\S+)$/
      # '+ 3 days' => 3.days.from_now
      $2.to_i.send($3.to_sym).send($1 == '+' ? :from_now : :ago)
    else
      Time.parse( date_string )
    end
  end
end

World(MiscHelpers)
