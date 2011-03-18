module SectionHelpers
  def xpath_of_section(section_name, prefix = "//")
    case section_name

    when "h1"
      "#{prefix}h1"
    when "sub nav"
      "#{prefix}div[@id='sub_tabnav']"
    else
      raise "Can't find mapping from \"#{section_name}\" to a section."
    end
  end
end

World(SectionHelpers)
