namespace :survey_monkey do
  desc 'Import the data from the survey monkey csv file'
  task :import => :environment do
    csv_filename = Rails.root.join("tmp", "survey_monkey", "20100704.csv")
    SurveyMonkey.import_from_csv(csv_filename)
  end
end
