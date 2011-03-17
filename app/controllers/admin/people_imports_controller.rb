class Admin::PeopleImportsController < Admin::AdminController
  def index
    @csv_directory = PeopleImport.s3_csv_directory
    @csv_s3_objects = PeopleImport.s3_csv_objects
  end

  def new
    @csv_object = PeopleImport.find_csv_by_s3_key(params[:key])
    @network_options = [["--- Select a network ---", nil]] + Network.all(:order => :name).map { |n| [n.name, n.id] }
    @people_import = PeopleImport.new
  end
end
