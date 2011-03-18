class ModelAttributes
  def self.construct(keys, values)
    raise ArgumentError.new("Sizes of keys and values do not match") unless keys.size == values.size
    hash = {}
    keys.each_with_index do |key, index|
      key_copy = key.dup
      value = values[index]
      while key_copy =~ /\[/ do
        key_copy =~ /^(.*)\[([^\]]+)\]$/
        raise ArgumentError.new("Unable to parse key: \"#{key}\"") unless ($1 && $2)
        key_copy = $1
        value = { $2 => value }
      end
      raise ArgumentError.new("Key can not be blank (\"#{key}\")") if key.blank?
      raise ArgumentError.new("Unmatched ']' in key (\"#{key}\")") if key_copy =~ /\]/
      hash.deep_merge!(key_copy => value)
    end
    hash
  end
end
