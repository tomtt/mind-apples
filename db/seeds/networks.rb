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
    "form_header" => "<img align='right' alt='Wellbeing and Health in Lambeth' src='/images/networks/lambeth_wellbeing_logo.jpg' />Mindapples is working with NHS Lambeth to find out what people in Lambeth like doing to look after their minds. <br /><br />Share your 5-a-day, and browse the community to see what other people in Lambeth say works for them. We'll also share all your suggestions anonymously back with NHS Lambeth to tell them what local people want and need to be happy and healthy."
  }

  @@network_data << {
    "name" => "4Beauty",
    "url" => "4beauty",
    "form_header" => "<img align='right' alt='Mindapples and 4Beauty' src='/images/networks/4beauty_logo.jpg' />We want to find out what 4Beauty viewers like doing to look after their minds. <br /><br />Share your 5-a-day, and browse the community to see what other Channel 4 viewers say works for them. We'll also share all your suggestions anonymously back with Channel 4 to tell them what you want and need to be happy and healthy."
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
