class Admin::PeopleImportsController < Admin::AdminController
  def new
    @network_options = [["--- Select a network ---", "none"]] + Network.all(:order => :name).map { |n| [n.name, n.id] }
  end
end
