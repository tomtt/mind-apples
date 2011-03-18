module XpathClassSelector
  def with_class(css_class)
    "contains(concat(' ',normalize-space(@class),' '),' #{css_class} ')"
  end
end

World(XpathClassSelector)
