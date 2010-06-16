module SectionHelpers
  def xpath_of_section(section_name, prefix = "//")
    case section_name

    when 'the main navigation'
      "#{prefix}*[contains(@class, 'main_nav')]"
    when 'the browser page title'
      "#{prefix}title"
    when /^a single (hidden |)h1$/
      xpath_search('//h1').size.should == 1
      h1_class = "contains(@class, 'hidden')"
      h1_class = "not(#{h1_class})" if $1.blank?
      "#{prefix}h1[#{h1_class}]"
    when 'the pagination'
      "#{prefix}*[contains(@class, 'pagination')]"
    when "the title block"
      "#{prefix}*[contains(@class, 'title_block')]"

    when "the Unboxed Latest section"
      "#{prefix}*[contains(@class, 'unboxed_latest')]"

    when "the blog index"
      "#{prefix}*[contains(@class, 'blogging')]"
    when /^the blog index item for "([^\"]*)"$/
      xpath_of_section("the blog index", prefix) + "//h2[. = '#{$1}']//ancestor::*[contains(@class, 'blog')][1]"
    when "the blog post section"
      "#{prefix}*[contains(@class, 'blogging')]//*[contains(@class, 'blog')]"
      
    when "the page"
      "#{prefix}body"
      
    else
      raise "Can't find mapping from \"#{section_name}\" to a section."
    end
  end
end

World(SectionHelpers)
