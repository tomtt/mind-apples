# == Schema Information
#
# Table name: mindapples
#
#  id                      :integer         not null, primary key
#  suggestion              :text
#  person_id               :integer
#  created_at              :datetime
#  updated_at              :datetime
#  mindapple_likings_count :integer
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mindapple do
  before(:each) do
    @valid_attributes = {
      :suggestion => "value for suggestion",
      :person_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Mindapple.create!(@valid_attributes)
  end

  describe "associations" do
    describe "people that like a mindapple" do
      it "responds to fans method" do
        mindapple = Factory.create(:mindapple)
        mindapple.respond_to?('fans').should == true
      end

      it "returns an array of people that like the mindapple" do
        mindapple = Factory.create(:mindapple)
        person1 = Factory.create(:person, :email => "person1@email.com")
        person2 = Factory.create(:person, :email => "person2@email.com")

        person1.liked_mindapples << mindapple
        person2.liked_mindapples << mindapple

        mindapple.fans.should include(person1)
        mindapple.fans.should include(person2)
      end
    end
  end

  describe "most_liked" do

    before(:each) do
      @mindapple_1 = Factory.create(:mindapple)
      @mindapple_2 = Factory.create(:mindapple)
      @mindapple_3 = Factory.create(:mindapple)
      @mindapple_4 = Factory.create(:mindapple)
      @mindapple_5 = Factory.create(:mindapple)
      @mindapple_6 = Factory.create(:mindapple)

      make_people_like_mindapple(5, @mindapple_1)
      make_people_like_mindapple(5, @mindapple_2)
      make_people_like_mindapple(3, @mindapple_3)
      make_people_like_mindapple(2, @mindapple_4)
      make_people_like_mindapple(1, @mindapple_5)

      @max = 5
    end

    it "returns N mindapples if there are N or more than N in the top-N" do
      most_liked = Mindapple.most_liked(@max)

      most_liked.size.should == @max
    end

    it "returns the N most liked mindapples if there are N or more than N in the top-N" do
      most_liked = Mindapple.most_liked(@max)

      most_liked.should include(@mindapple_1)
      most_liked.should include(@mindapple_2)
      most_liked.should include(@mindapple_3)
      most_liked.should include(@mindapple_4)
      most_liked.should include(@mindapple_5)
    end

    it "doesn't return a mindapple if it's not one of the most liked top-N" do
      most_liked = Mindapple.most_liked(@max)

      most_liked.should_not include(@mindapple_6)
    end

  end

  describe "most_liked_within_network" do

    before(:each) do
      @network_a = Factory.create(:network)
      @network_b = Factory.create(:network)
      @person_a = Factory.create(:person, :network => @network_a)
      @person_b = Factory.create(:person, :network => @network_b)
      @mindapple_1_a = Factory.create(:mindapple, :person => @person_a)
      @mindapple_2_a = Factory.create(:mindapple, :person => @person_a)
      @mindapple_3_a = Factory.create(:mindapple, :person => @person_a)
      @mindapple_4_a = Factory.create(:mindapple, :person => @person_a)
      @mindapple_5_a = Factory.create(:mindapple, :person => @person_a)
      @mindapple_6_a = Factory.create(:mindapple, :person => @person_a)
      @mindapple_1_b = Factory.create(:mindapple, :person => @person_b)
      @mindapple_2_b = Factory.create(:mindapple, :person => @person_b)
      @mindapple_3_b = Factory.create(:mindapple, :person => @person_b)
      @mindapple_4_b = Factory.create(:mindapple, :person => @person_b)
      @mindapple_5_b = Factory.create(:mindapple, :person => @person_b)
      @mindapple_6_b = Factory.create(:mindapple, :person => @person_b)

      make_people_like_mindapple(5, @mindapple_1_a)
      make_people_like_mindapple(5, @mindapple_2_a)
      make_people_like_mindapple(4, @mindapple_3_a)
      make_people_like_mindapple(3, @mindapple_4_a)
      make_people_like_mindapple(1, @mindapple_5_a)

      make_people_like_mindapple(7, @mindapple_1_b)
      make_people_like_mindapple(7, @mindapple_2_b)
      make_people_like_mindapple(2, @mindapple_3_b)
      make_people_like_mindapple(1, @mindapple_4_b)
      make_people_like_mindapple(9, @mindapple_5_b)

      @max = 5
    end

    it "returns N mindapples if there are N or more than N in the top-N" do
      most_liked = Mindapple.most_liked_within_network(@network_a, @max)

      most_liked.size.should == @max
    end

    it "returns the N most liked mindapples if there are N or more than N in the top-N" do
      most_liked = Mindapple.most_liked_within_network(@network_a, @max)

      most_liked.should include(@mindapple_1_a)
      most_liked.should include(@mindapple_2_a)
      most_liked.should include(@mindapple_3_a)
      most_liked.should include(@mindapple_4_a)
      most_liked.should include(@mindapple_5_a)
    end

    it "doesn't return a mindapple if it's not one of the most liked top-N" do
      most_liked = Mindapple.most_liked_within_network(@network_a, @max)

      most_liked.should_not include(@mindapple_6_a)
    end

    it "returns an empty list if ni is passed as the network" do
      most_liked = Mindapple.most_liked_within_network(nil, 3)
      most_liked.should == []
    end
  end

  describe "most_recent" do
    context "with example mindapples" do
      before(:each) do
        @person1 = Factory.create(:person, :email=> "#{rand}_test@email.com")

        @mindapple_1_1 = Factory.create(:mindapple, :person => @person1, :created_at => 3.minute.ago, :suggestion => "boo")
        @mindapple_1_2 = Factory.create(:mindapple, :person => @person1, :created_at => 3.minute.ago, :suggestion => "boo")
        @mindapple_1_3 = Factory.create(:mindapple, :person => @person1, :created_at => 3.minute.ago, :suggestion => "boo")
        @mindapple_1_4 = Factory.create(:mindapple, :person => @person1, :created_at => 3.minute.ago, :suggestion => "boo")
        @mindapple_1_5 = Factory.create(:mindapple, :person => @person1, :created_at => 3.minute.ago, :suggestion => "boo")

        @person2 = Factory.create(:person, :email=> "#{rand}_test@email.com")

        @mindapple_2_1 = Factory.create(:mindapple, :person => @person2, :created_at => 2.minute.ago, :suggestion => "boo")
        @mindapple_2_2 = Factory.create(:mindapple, :person => @person2, :created_at => 2.minute.ago, :suggestion => "boo")
        @mindapple_2_3 = Factory.create(:mindapple, :person => @person2, :created_at => 2.minute.ago, :suggestion => "boo")
        @mindapple_2_4 = Factory.create(:mindapple, :person => @person2, :created_at => 2.minute.ago, :suggestion => "boo")
        @mindapple_2_5 = Factory.create(:mindapple, :person => @person2, :created_at => 2.minute.ago, :suggestion => "boo")

        @person3 = Factory.create(:person, :email=> "#{rand}_test@email.com")
        @mindapple_3_1 = Factory.create(:mindapple, :person => @person3, :created_at => 1.minute.ago, :suggestion => "boo")
        @mindapple_3_2 = Factory.create(:mindapple, :person => @person3, :created_at => 1.minute.ago, :suggestion => "boo")
        @mindapple_3_3 = Factory.create(:mindapple, :person => @person3, :created_at => 1.minute.ago, :suggestion => "boo")
        @mindapple_3_4 = Factory.create(:mindapple, :person => @person3, :created_at => 1.minute.ago, :suggestion => "boo")
        @mindapple_3_5 = Factory.create(:mindapple, :person => @person3, :created_at => 1.minute.ago, :suggestion => "boo")

        @max = 5
      end

      it "returns N mindapples if there are N or more than N in the most recent top-N" do
        pend_when_not_using_postgres
        most_recent = Mindapple.most_recent(@max)

        most_recent.size.should == 3
      end

      it "returns the N most recent mindapples if there are N or more than N in the top-N" do
        pend_when_not_using_postgres
        most_recent = Mindapple.most_recent(@max)
        people_ids = most_recent.map {|e| e.person_id}

        people_ids.should include(@person1.id)
        people_ids.should include(@person2.id)
        people_ids.should include(@person3.id)
      end

      it "returns the N most recent ordered by created_at DESC" do
        pend_when_not_using_postgres
        most_recent = Mindapple.most_recent(@max)

        most_recent[0].created_at.should >= most_recent[1].created_at
        most_recent[1].created_at.should >= most_recent[2].created_at
      end
    end

    it "does not return any mindapples that have no suggestion" do
      pend_when_not_using_postgres
      @person = Factory.create(:person, :email=> "#{rand}_test@email.com")
      @mindapple = Factory.create(:mindapple, :person => @person, :created_at => 1.minute.ago, :suggestion => "")
      Mindapple.most_recent(3).should be_empty
    end
  end

  def make_people_like_mindapple(number_of_fans, mindapple)
    (1..number_of_fans.to_i).each do |i|
      person = Factory.create(:person, :email=> "#{rand}_test_#{i}@email.com")
      person.liked_mindapples << mindapple
    end
  end

  describe "search_by_suggestion" do
    it "returns all mindappples containing searchable param" do
      mindapple = Factory.create(:mindapple, :suggestion => 'Runing in the park')
      mindapple2 = Factory.create(:mindapple, :suggestion => 'Eating ice cream')
      mindapple3 = Factory.create(:mindapple, :suggestion => 'Sleeping in the park')
      mindapples = Mindapple.search_by_suggestion('park')

      mindapples.size.should == 2
      mindapples.should include(mindapple, mindapple3)
    end
  end

  describe "belonging_to_network" do
    it "returns only all mindappples posted by people in the network" do
      network1 = Factory.create(:network, :name => "one")
      network2 = Factory.create(:network, :name => "two")

      person1a = Factory.create(:person, :network => network1)
      person1b = Factory.create(:person, :network => network1)
      person2a = Factory.create(:person, :network => network2)
      person2b = Factory.create(:person, :network => network2)
      person3a = Factory.create(:person, :network => nil)
      person3b = Factory.create(:person, :network => nil)

      mindapple1a = Factory.create(:mindapple, :person => person1a)
      mindapple1b = Factory.create(:mindapple, :person => person1b)
      mindapple2a = Factory.create(:mindapple, :person => person2a)
      mindapple2b = Factory.create(:mindapple, :person => person2b)
      mindapple3a = Factory.create(:mindapple, :person => person3a)
      mindapple3b = Factory.create(:mindapple, :person => person3b)

      mindapples = Mindapple.belonging_to_network(network2)

      mindapples.size.should == 2
      mindapples.should include(mindapple2a, mindapple2b)
    end

    it "does not blow up if the passed network is nil" do
      Mindapple.belonging_to_network(nil).should == []
    end
  end
  
  describe "set_mindapples_shared" do
    it "should set the mindapples_shared? field on a user to true if the mindapple is created" do
      person = Factory.create(:person)
      mindapple = Factory.create(:mindapple, :person => person)
      person.reload
      person.shared_mindapples?.should == false
    end
  end
end

