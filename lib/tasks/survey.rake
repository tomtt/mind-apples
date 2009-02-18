namespace :mind_apples do
  desc "Import the data from survey monkey results"
  task :import_survey_data do
    def check_labels(labels)
      expected_labels = ["RespondentID", # 0
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
      labels.each_with_index do |label, index|
        unless label == expected_labels[index]
          raise "Label #{index} has unexpected label #{label} (expected #{expected_labels[index]})"
        end
      end
    end

    def extract_data_rows(csv_filename)
      require 'fastercsv'
      labels = nil
      data_types = nil
      data = []

      FasterCSV.foreach(csv_filename) do |row|
        if labels.nil?
          labels = row
          next
        end

        if data_types.nil?
          data_types = row
          next
        end
        data << row
      end

      check_labels(labels)
      data
    end

    def add_response(data_row)
      require 'environment'
      
      respondent_id = data_row[0]
      return if Survey.find_by_respondent_id(respondent_id)
      survey = Survey.create!(:respondent_id => respondent_id,
                              :apple_1 => data_row[9],
                              :apple_2 => data_row[10],
                              :apple_3 => data_row[11],
                              :apple_4 => data_row[12],
                              :apple_5 => data_row[13],
                              :brain_dump => data_row[14],
                              :health_check => data_row[15],
                              :famous_fives => data_row[16],
                              :gender => data_row[17],
                              :age_range => data_row[18],
                              :country => data_row[19],
                              :name => data_row[20],
                              :email => data_row[21],
                              :start_date => DateTime.parse(data_row[2]),
                              :end_date => DateTime.parse(data_row[3]))
      puts "Created survey for #{survey.name} (#{respondent_id})"
    end
    
    csv_filename = File.join(ENV['HOME'],
                             'created',
                             'projects',
                             'mindapples',
                             'survey',
                             'CSV_20090218',
                             'Sheet_1.csv')
    data_rows = extract_data_rows(csv_filename)
    data_rows.each do |data_row|
      add_response(data_row)
    end
  end
end
