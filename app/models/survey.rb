class Survey < ActiveRecord::Base
  before_validation_on_create :create_auth_code

  named_scope :containing_phrase, lambda{ |phrase|
    search_condition = (1..5).map { |i| "apple_#{i} like ?" }.join(" or ")
    { :conditions => [search_condition] + (1..5).map { "%#{phrase}%" } }
  }

  private

  def create_auth_code
    self.private_auth = RandomString.generate
  end
end
