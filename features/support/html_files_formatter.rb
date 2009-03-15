require File.dirname(__FILE__) + '/formatter_shared'

begin
  require 'builder'
rescue LoadError
  gem 'builder'
  require 'builder'
end

module Cucumber
  module Formatter
    class FeatureStatistics
      def initialize
        @step_status_count = {}
        @step_count = 0
        @scenario_count = 0
      end

      def count_step_status(status)
        @step_status_count[status] ||= 0
        @step_status_count[status] += 1
        @step_count += 1
      end

      def count_scenario
        @scenario_count += 1
      end

      def get_count(status)
        @step_status_count[status] || 0
      end

      def get_scenario_count
        @scenario_count
      end

      def get_total_step_count
        @step_count
      end
    end

    class HtmlFiles < Ast::Visitor
      include Cucumber::Trac
      include Cucumber::Feature

      FEATURE_HTML_PATH = File.join(RAILS_ROOT, 'public', 'features')
      TRAC_TICKETS_URL = "https://extranet.unboxedconsulting.com/trac/lather/ticket"

      def initialize(step_mother, io, options)
        super(step_mother)
        @trac_numbers_generated = {}
        @feature_statistics = {}
        FileUtils.mkdir_p(FEATURE_HTML_PATH)
      end

      def feature_statistics(feature)
        @feature_statistics[feature] ||= FeatureStatistics.new
      end

      def count_step_status(feature, status)
        feature_statistics(feature).count_step_status(status)
      end

      def count_scenario(feature)
        feature_statistics(feature).count_scenario
      end

      def html_file_name(trac_number)
        "trac_%s.html" % trac_number
      end

      def build_index
        statuses = [:failed, :skipped, :undefined, :pending, :passed]

        index_file = File.open("%s/index.html" % FEATURE_HTML_PATH, "w")
        @index_builder = Builder::XmlMarkup.new(:target => index_file, :indent => 2)
        # <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
        @index_builder.declare!(
          :DOCTYPE,
          :html,
          :PUBLIC,
          '-//W3C//DTD XHTML 1.0 Strict//EN',
          'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'
        )
        @index_builder.html(:xmlns => 'http://www.w3.org/1999/xhtml') do
          @index_builder.head do
            @index_builder.title 'Cucumber'
            inline_css(@index_builder)
            inline_javascript(@index_builder)
          end
          @index_builder.body do
            @index_builder.div(:class => 'cucumber') do
              @index_builder.table(:class => 'features sorted') do
                @index_builder.thead do
                  @index_builder.tr do
                    @index_builder.th("Ticket", :rowspan => 3)
                    @index_builder.th("Description", :rowspan => 3)
                    @index_builder.th("Stage", :rowspan => 3)
                    @index_builder.th("Count", :colspan => statuses.size + 1)
                    @index_builder.th("Passing", :rowspan => 3)
                    @index_builder.th("Progress", :rowspan => 3)
                  end
                  @index_builder.tr do
                    @index_builder.th("Scenarios", :rowspan => 2)
                    @index_builder.th("Steps", :colspan => statuses.size)
                  end
                  @index_builder.tr do
                    statuses.each do |status|
                      @index_builder.th status.to_s
                    end
                  end
                end
                @index_builder.tbody do
                  @feature_statistics.keys.each do |feature|

                    @index_builder.tr do
                      @index_builder.td(:class => 'ticket-reference') do
                        trac_numbers = feature_trac_numbers(feature)
                        trac_numbers.each do |trac_number|
                          @index_builder.a(trac_number.to_i,
                                           :href => "#{TRAC_TICKETS_URL}/%d" % trac_number.to_i,
                                           :target => '_new')
                        end
                      end
                      file_name = html_file_name(feature_trac_numbers(feature).first)
                      @index_builder.td(:class => 'feature-name') do
                        @index_builder.a(feature_name(feature),
                                         :href => file_name)
                      end
                      stage = stage_of_feature(feature)
                      @index_builder.td(stage,
                                        :class => "feature-stage #{stage}")
                      @index_builder.td(:class => 'scenario-count') do
                        # @index_builder.text!("%d" % feature_statistics(feature).get_scenario_count)
                        @index_builder.text!("?")
                      end
                      statuses.each do |status|
                        @index_builder.td("%d" % feature_statistics(feature).get_count(status),
                                          :class => "status-count #{status.to_s}")
                      end
                      passed_steps = feature_statistics(feature).get_count(:passed)
                      total_steps = feature_statistics(feature).get_total_step_count
                      percentage_passing = (passed_steps.to_f / total_steps) * 100
                      @index_builder.td("%.1f%" % percentage_passing,
                                        :class => 'percentage-passing')
                      @index_builder.td(:class => 'scenario-count') do
                        @index_builder.table(:cellspacing => 0,
                                             :class => 'percent_graph',
                                             :cellpadding => 0,
                                             :width => 100) do
                          @index_builder.tr do
                            @index_builder.td(:class => 'covered', :width => percentage_passing.to_i)
                            @index_builder.td(:class => 'uncovered', :width => 100 - percentage_passing.to_i)
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end

      def visit_features(features)
        super
        build_index
      end

      def increase_step_status(status)
        @steps[steps] ||= 0
        @steps[steps] += 1
      end

      def visit_step_name(keyword, step_name, status, step_definition, source_indent)
        @builder.li("#{keyword} #{step_name}", :class => status)
        count_step_status(@current_feature, status)
      end

      def visit_scenario_name(keyword, name, file_line, source_indent)
        count_scenario(@current_feature)
        super
      end

      def visit_feature(feature)
        io = ""
        @current_feature = feature

        @builder = Builder::XmlMarkup.new(:target => io, :indent => 2)
        @steps = {}

        # <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
        @builder.declare!(
                          :DOCTYPE,
                          :html,
                          :PUBLIC,
                          '-//W3C//DTD XHTML 1.0 Strict//EN',
                          'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'
                          )
        @builder.html(:xmlns => 'http://www.w3.org/1999/xhtml') do
          @builder.head do
            @builder.title 'Cucumber'
            inline_css(@builder)
          end
          @builder.body do
            @builder.div(:class => 'cucumber') do
              @builder.div(:class => 'feature') do
                super
              end
            end
          end
        end

        trac_numbers = feature_trac_numbers(feature)
        trac_numbers.each do |trac_number|
          if @trac_numbers_generated[trac_number]
            raise "A file was already generated for trac number %s" % trac_number
          end
          @trac_numbers_generated[trac_number] = feature
          file_name = html_file_name(trac_number)
          File.open("%s/%s" % [FEATURE_HTML_PATH, file_name], "w") { |file| file << io }
        end
      end

      def visit_feature_name(name)
        lines = name.split(/\r?\n/)
        @builder.h2(lines[0])
        @builder.p do
          return if lines.empty?
          lines[1..-1].each do |line|
            @builder.text!(line.strip)
            @builder.br
          end
        end
      end

      def visit_background(background)
        @builder.div(:class => 'background') do
          @builder.ol do
            super
          end
        end
      end

      def visit_feature_element(feature_element)
        @builder.div(:class => 'scenario') do
          super
        end
        @open_step_list = true
      end

      def visit_scenario_name(keyword, name, file_line, source_indent)
        @builder.h3("#{keyword} #{name}")
      end

      def visit_outline_table(outline_table)
        @builder.table do
          super(outline_table)
        end
      end

      def visit_examples_name(keyword, name)
        @builder.h4("#{keyword} #{name}")
      end

      def visit_steps(scenarios)
        @builder.ol do
          super
        end
      end

      def visit_multiline_arg(multiline_arg, status)
        if Ast::Table === multiline_arg
          @builder.table do
            super(multiline_arg, status)
          end
        else
          @builder.p do
            super(multiline_arg, status)
          end
        end
      end

      def visit_table_row(table_row, status)
        @builder.tr do
          super(table_row, status)
        end
      end

      def visit_table_cell_value(value, width, status)
        @builder.td(value, :class => status)
      end

      private

      def inline_javascript(builder)
        builder.script(:src => "/javascripts/jquery/jquery-1.3.2.min.js",
                       :type => "text/javascript") {}
        builder.script(:src => "/javascripts/jquery/jquery.tablesorter-2.0.3.min.js",
                       :type => "text/javascript") {}
        builder.script(:src => "/javascripts/cucumber.js",
                       :type => "text/javascript") {}
      end

      def inline_css(builder)
        builder.link(:href => '/stylesheets/cucumber.css',
                     :rel => "stylesheet",
                     :type => "text/css")
        builder.link(:href => '/stylesheets/tablesorter.css',
                     :rel => "stylesheet",
                     :type => "text/css")
      end
    end
  end
end
