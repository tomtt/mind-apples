module Mindapples
  class Config
    @@config = YAML.load_file("#{RAILS_ROOT}/config/mindapples.yml")[RAILS_ENV]

    def self.[](key)
      @@config[key]
    end

    def self.keys
      @@config.keys
    end

    def self.to_hash
      @@config.dup
    end
  end
end
