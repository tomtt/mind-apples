class PageCode
  DEFAULT_SIZE = 8
  CHARACTERS =
    ('a'..'z').to_a +
    ('A'..'Z').to_a +
    ('0'..'9').to_a

  def self.code(size = DEFAULT_SIZE)
    s = ''
    size.times { s << CHARACTERS[rand(CHARACTERS.size)] }
    s
  end
end
