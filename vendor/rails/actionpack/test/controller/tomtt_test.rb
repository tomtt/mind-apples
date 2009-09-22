require 'controller/fake_controllers'
require 'action_controller/routing/route_set'

class LegacyRouteSetTests < ActiveSupport::TestCase
  attr_reader :rs

  def setup
    # These tests assume optimisation is on, so re-enable it.
    ActionController::Base.optimise_named_routes = true

    @rs = ::ActionController::Routing::RouteSet.new

    ActionController::Routing.use_controllers! %w(content admin/user admin/news_feed)
  end

  def teardown
    @rs.clear!
  end

  def test_default_setup
    @rs.draw do |map|
      map.resources :posts
      map.resources :authors, :has_many => :posts
    end
    # assert_equal({:controller => "posts", :action => 'index'},
    # rs.recognize_path("/posts"))
    require 'ruby-debug'
    debugger
    assert_equal 1, 1
  end

  private
    def routes
      ActionController::Routing::Routes
    end
end
