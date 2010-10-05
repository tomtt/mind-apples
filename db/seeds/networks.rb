#######
#
# This file will be run on every deploy, so make sure the changes here are non-destructive
#
#######

module NetworkSeeds
  @@network_data = []
  @@network_data << {
    "name" => "Lambeth",
    "url" => "lambeth",
    "form_header" => "This Mindapples five-a-day form was made for Lambeth"
  }

  @@network_data << {
    "name" => "4Beauty",
    "url" => "4beauty",
    "form_header" => "This Mindapples five-a-day form was made for 4Beauty"
  }

  def self.seed_all
    @@network_data.each { |data| seed_network(data) }
  end

  private

  def self.seed_network(data)
    url = data["url"] || raise("No url defined in network data: '#{data.inspect}'")
    network = Network.find_by_url(url) || Network.new
    network.update_attributes!(data)
  end
end

NetworkSeeds.seed_all
