namespace :survey_monkey do
  desc 'Import the data from the survey monkey csv file'
  task :import => :environment do
    csv_filename = ENV["CSV_FILE"]
    if csv_filename.blank?
      raise("No CSV_FILE set for survey_monkey:import task")
    end
    SurveyMonkey.import_from_csv(csv_filename)
  end
end
