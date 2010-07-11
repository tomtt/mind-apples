class EmailValidation
  def self.valid?(email)
    begin
      return false if email.blank?
      address = TMail::Address.parse(email)
      return false unless address.is_a?(TMail::Address)
      !! ( address.domain =~ /\A([a-z0-9][a-z0-9-]*[a-z0-9]\.)+[a-z0-9]{2,}\Z/i )
    rescue TMail::SyntaxError
      return false
    end
  end
end
