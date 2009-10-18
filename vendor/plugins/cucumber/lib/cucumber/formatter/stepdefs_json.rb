require 'cucumber/formatter/usage'

module Cucumber
  module Formatter
    class StepdefsJson < Usage

      # @stepdef_to_match is a hash with step definitions as keys and
      # a list of matches as value
      #
      # What we want is to export is a hash with the step regexp as
      # the key and a uniquified sorted list of steps as the value
      def build_regexp_usage_structure
        regexp_uses_hash = {}
        @stepdef_to_match.to_a.each do |step_matches_pair|
          step_text = StepdefsJson.extract_text_from_regexp(step_matches_pair[0].regexp_source)
          matches = step_matches_pair[1].map{|m| m[:step_match].format_args}.uniq.sort
          regexp_uses_hash[step_text] = matches
        end
        json = regexp_uses_hash
      end

      def self.extract_text_from_regexp(regexp)
        prompt = '??'
        regexp.sub!(/^\/\^?/, '')
        regexp.sub!(/\$?\/$/, '')
        regexp.gsub!(/\(\[\^\\?\"\]\*\??\)/, prompt)
        regexp.gsub!('(.*)', prompt)
        regexp.gsub!('\/([^\/]*)\/', "/#{prompt}/")
        regexp
      end

      def progress(status)
      end

      def print_summary(features)
        add_unused_stepdefs
        @io.print "cucumberStepCompletion.cucumberSteps = " + build_regexp_usage_structure.to_json
      end
    end
  end
end
