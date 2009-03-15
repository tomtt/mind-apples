module Cucumber
  module Trac
    private

    def feature_trac_numbers(feature)
      tags = feature.instance_eval("@tags").instance_eval("@tag_names")
      trac_tags = tags.select { |tag| tag.match(Regexp.new("^trac_")) }
      trac_tags.sort.map { |tag| tag.sub(/^trac_/, '') }
    end
  end

  module Feature
    STAGES = %w[transitional development committed]

    private

    def feature_description(feature)
      feature.instance_eval("@name")
    end

    def feature_name(feature)
      feature_line = feature_description(feature).split(/\n/).first
      if feature_line.match(/Feature: (.*)/)
        return $1
      else
        raise "Could not find feature name in feature line \"#{feature_line}\""
      end
    end

    def stage_of_feature(feature)
      tagged_stage = nil
      STAGES.each do |stage|
        if feature.tagged_with?(stage)
          if tagged_stage
            raise "Feature \"#{feature_name(feature)}\" has multiple stage tags"
          else
            tagged_stage = stage
          end
        end
      end
      tagged_stage
    end
  end
end
