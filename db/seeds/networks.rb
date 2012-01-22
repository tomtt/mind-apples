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
    "description" => "<p>Mindapples is working with the NHS to find out what people in Lambeth do to look after their minds.</p>\
                      <p>Here you can share what works for you, and find out what other people in Lambeth say works for them. We'll also share the suggestions anonymously with the NHS to tell them what Lambeth folks need to be happy and healthy.</p>",
    "logo" => File.open(File.join(RAILS_ROOT, 'db', 'seeds', 'images', 'lambeth_wellbeing_logo.jpg'))
  }

  @@network_data << {
    "name" => "Secret Garden Party",
    "url" => "sgp",
    "description" => "<p>Did you share the 5-a-day for your mind at the Secret Garden Party? We've uploaded all your suggestions here so you can see what other festival-goers do to look after their minds.</p>",
    "logo" => File.open(File.join(RAILS_ROOT, 'db', 'seeds', 'images', 'sgp.jpg'))
  }

  @@network_data << {
    "name" => "Wilderness Festival",
    "url" => "wilderness",
    "description" => "<p>Did you share the 5-a-day for your mind at the Wilderness Festival? We've uploaded all your suggestions here so you can see what other festival-goers do to look after their minds.</p>",
    "logo" => File.open(File.join(RAILS_ROOT, 'db', 'seeds', 'images', 'wilderness.jpg'))
  }

  @@network_data << {
    "name" => "Larmer Tree",
    "url" => "larmertree",
    "description" => "<p>Did you share the 5-a-day for your mind at Larmer Tree? We've uploaded all your suggestions here so you can see what other festival-goers do to look after their minds.</p>",
    "logo" => File.open(File.join(RAILS_ROOT, 'db', 'seeds', 'images', 'larmertree.jpg'))
  }

  @@network_data << {
    "name" => "Big Chill",
    "url" => "bigchill",
    "description" => "<p>Did you share the 5-a-day for your mind at the Big Chill? We've uploaded all your suggestions here so you can see what other festival-goers do to look after their minds.</p>",
    "logo" => File.open(File.join(RAILS_ROOT, 'db', 'seeds', 'images', 'bigchill.jpg'))
  }

  @@network_data << {
    "name" => "Camp Bestival",
    "url" => "campbestival",
    "description" => "<p>Did you share the 5-a-day for your mind at Camp Bestival? We've uploaded all your suggestions here so you can see what other festival-goers do to look after their minds.</p>",
    "logo" => File.open(File.join(RAILS_ROOT, 'db', 'seeds', 'images', 'campbestival.jpg'))
  }

  @@network_data << {
    "name" => "Playgroup",
    "url" => "playgroup",
    "description" => "<p>Did you share the 5-a-day for your mind at Playgroup? We've uploaded all your suggestions here so you can see what other festival-goers do to look after their minds.</p>",
    "logo" => File.open(File.join(RAILS_ROOT, 'db', 'seeds', 'images', 'playgroup.jpg'))
  }

  @@network_data << {
    "name" => "Thames Festival",
    "url" => "thamesfestival",
    "description" => "<p>Did you share the 5-a-day for your mind at the Thames Festival? We've uploaded all your suggestions here so you can see what other festival-goers do to look after their minds.</p>",
    "logo" => File.open(File.join(RAILS_ROOT, 'db', 'seeds', 'images', 'thamesfestival.jpg'))
  }

  @@network_data << {
    "name" => "Action for Happiness",
    "url" => "afh",
    "description" => "<p>Have you shared your mindapples? Tell us the 5-a-day for your mind here, and browse the suggestions to see what other people in the Action for Happiness community do to look after their minds.</p>",
    "logo" => File.open(File.join(RAILS_ROOT, 'db', 'seeds', 'images', 'actionforhappiness.jpg'))
  }

  @@network_data << {
    "name" => "South London and Maudsley",
    "url" => "slam",
    "description" => "<p>Have you shared your mindapples? Tell us the 5-a-day for your mind here, and browse the suggestions to see what other people in South London and Maudsley NHS do to look after their minds.</p>",
    "logo" => File.open(File.join(RAILS_ROOT, 'db', 'seeds', 'images', 'slam.jpg'))
  }

  @@network_data << {
    "name" => "Channel 4",
    "url" => "channel4",
    "description" => "<p>Have you shared your mindapples? Tell us the 5-a-day for your mind here, and browse the suggestions to see what other people at Channel 4 do to look after their minds.</p>",
    "logo" => File.open(File.join(RAILS_ROOT, 'db', 'seeds', 'images', 'channel4.jpg'))
  }

  @@network_data << {
    "name" => "Roche",
    "url" => "roche",
    "description" => "<p>Have you shared your mindapples? Tell us the 5-a-day for your mind here, and browse the suggestions to see what other people at Roche do to look after their minds.</p>",
    "logo" => File.open(File.join(RAILS_ROOT, 'db', 'seeds', 'images', 'roche.jpg'))
  }

  @@network_data << {
    "name" => "Centrica",
    "url" => "centrica",
    "description" => "<p>Have you shared your mindapples? Tell us the 5-a-day for your mind here, and browse the suggestions to see what other people at Centrica do to look after their minds.</p>",
    "logo" => File.open(File.join(RAILS_ROOT, 'db', 'seeds', 'images', 'centrica.jpg'))
  }

  @@network_data << {
    "name" => "Goldman Sachs",
    "url" => "gs",
    "description" => "<p>What do you do to look after your mind? Tell us the 5-a-day for your mind here, and browse the suggestions to see what other people at Goldman Sachs do to look after their minds.</p>",
    "logo" => File.open(File.join(RAILS_ROOT, 'db', 'seeds', 'images', 'gs.jpg'))
  }

  @@network_data << {
    "name" => "SOAS",
    "url" => "soas",
    "description" => "<p>Have you shared your mindapples? Tell us the 5-a-day for your mind here, and browse the suggestions to see what other people at SOAS do to look after their minds.</p>",
    "logo" => File.open(File.join(RAILS_ROOT, 'db', 'seeds', 'images', 'soas.jpg'))
  }

  @@network_data << {
    "name" => "Richmond College",
    "url" => "richmond",
    "description" => "<p>Have you shared your mindapples? Tell us the 5-a-day for your mind here, and browse the suggestions to see what other people at Richmond College do to look after their minds.</p>",
    "logo" => File.open(File.join(RAILS_ROOT, 'db', 'seeds', 'images', 'richmondcollege.jpg'))
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
