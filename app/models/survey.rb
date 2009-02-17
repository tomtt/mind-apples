class Survey < ActiveRecord::Base
  before_validation_on_create :create_auth_code

  private

  def create_auth_code
    self.private_auth = RandomString.generate
  end
end
