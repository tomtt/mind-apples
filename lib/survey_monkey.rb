# None of this code is tested. My excuse is that it's throwaway code:
# it is to be used only before public launch to perform the import of
# current survey monkey respondents

class SurveyMonkey
  def self.import_from_csv(csv_filename)
    SurveyMonkey.new.parse_csv(csv_filename)
  end

  def parse_csv(csv_filename)
    @labels = nil
    @data_types = nil
    @data = []
    extract_data_rows(csv_filename)

    check_labels!
    @data.each do |data_row|
      add_response(data_row)
    end
  end

  private

  def initialize
    @responses = []
    @expected_labels = ["RespondentID", # 0
                        "CollectorID", # 1
                        "StartDate", # 2
                        "EndDate", # 3
                        "IP Address", # 4
                        "Email Address", # 5
                        "First Name", # 6
                        "LastName", # 7
                        "Custom Data", # 8
                        "Important bit. What are your five?", # 9
                        nil, # 10
                        nil, # 11
                        nil, # 12
                        nil, # 13
                        "Brain dump. And anything else you'd like to tell us? What else do you need to stay mentally healthy\?", # 14
                        "Health check. How would you rate your mental health? (1 is bad, 5 good)", # 15
                        "Famous fives. Which well-known people would you most like us to contact about their five-a-days?", # 16
                        "Venus and Mars. What's your gender\?", # 17
                        "Age check. How old are you?", # 18
                        "Passport control. What country are you from?", # 19
                        "Be proud. What's your name? (very optional)", # 20
                        "Don't go! Leave your e-mail and we'll get in touch when the new website is up.", # 21
                        "We're new to this. Please let us know what you think of this survey so we can improve it.",
                        "How did you hear about Mindapples? If you were invited by a particular organisation, enter their name here."]
  end

  def extract_data_rows(csv_filename)
    require 'fastercsv'

    FasterCSV.foreach(csv_filename) do |row|
      if @labels.nil?
        @labels = row
        next
      end

      if @data_types.nil?
        @data_types = row
        next
      end
      @data << row
    end
  end

  def check_labels!
    @labels.each_with_index do |label, index|
      unless label == @expected_labels[index]
        raise "Label #{index} has unexpected label #{label} (expected #{@expected_labels[index]})"
      end
    end
  end

  def set_attribute(data_row, attributes, key, label_index)
    attributes[key] = data_row[label_index] unless data_row[label_index].blank?
  end

  def add_response(data_row)
    require "ruby-debug"
    attributes = {}

    set_attribute(data_row, attributes, :respondent_id, 0)
    person = Person.find_by_respondent_id(attributes[:respondent_id])
    unless person
      attribute_fields = [[:name, 20],
                          [:braindump, 14],
                          [:health_check, 15],
                          [:age, 18],
                          [:email, 21],
                          [:gender, 17],
                          [:health_check, 15],
                          [:location, 19]
                          # occupation?
                         ]
      attribute_fields.each do |key_index|
        set_attribute(data_row, attributes, key_index[0], key_index[1])
      end

      attributes[:email] = nil unless EmailValidation::valid?(attributes[:email])

      password = ActiveSupport::SecureRandom.hex(16)
      default_attributes = { :policy_checked => true, :public_profile => false }

      # puts "Importing %s, %s" % [attributes[:name], attributes[:email]]

      if attributes[:email] && Person.find_by_email(attributes[:email])
        puts "Email already exists: #{attributes.inspect}"
        return
      end

      Person.transaction do
        person = Person.create_with_random_password_and_login_and_page_code!(default_attributes.merge(attributes))
        5.times do |count|
          person.mindapples.create!(:suggestion => data_row[9 + count])
        end
      end
    end
  end
end
