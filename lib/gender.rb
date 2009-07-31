class Gender
  def self.label(value)
    case value
    when 'f'
      'Female'
    when 'm'
      'Male'
    else
      "It's complicated"
    end
  end
end
