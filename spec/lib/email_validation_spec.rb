require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EmailValidation do
  describe "valid?" do
    it "is true for valid email addresses" do
      valid_addresses = ["bob@example.com"]
      valid_addresses.each do |address|
        EmailValidation.valid?(address).should be_true
      end
    end

    it "is false for invalid email addresses" do
      invalid_addresses = ["bob.builder", # no hostname
                           "bob.builder@example.c-m", # weird char in hostname
                           "bob:builder", # colon
                           nil,
                           ""
                          ]
      invalid_addresses.each do |address|
        EmailValidation.valid?(address).should be_false
      end
    end

    it "should have more positive and negative examples, especially for the regexp that checks the domain"
  end
end
