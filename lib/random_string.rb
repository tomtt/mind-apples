class RandomString
  @@possible_chars = [('a'..'z'),('A'..'Z'),('0'..'9')].map{|i| i.to_a}.flatten;

  def self.generate(size = 10)
    (0...size).map { @@possible_chars[rand(@@possible_chars.length)]  }.join
  end
end
