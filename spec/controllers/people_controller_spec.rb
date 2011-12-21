require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PeopleController do
  def build_mock_person
    mock_person = mock_model(Person,
                             :ensure_correct_number_of_mindapples => nil,
                             :protected_login= => nil,
                             :page_code= => nil,
                             :save => true,
                             :update_attributes => true)
    mock_person
  end

  shared_examples_for "all actions finding a person" do
    it "should find a person by param value" do
      @person ||= Factory.create(:person)
      get 'show', :id => @person.to_param
      assigns[:person].should == @person
    end
  end

  describe "show" do
    it_should_behave_like "all actions finding a person"

    shared_examples_for "The user is the owner of a profile page" do
      it "should render the show template" do
        get 'show', :id => @person.to_param
        response.should be_success
        response.should render_template('show')
      end

      it "doesn't display a flash error message" do
        get 'show', :id => @person.to_param
        flash[:notice].should == nil
      end

      it "sets 'shared_mindapples? on the resource to true" do
        get 'show', :id => @person.to_param
        @person.reload
        @person.shared_mindapples?.should == true
      end
    end

    shared_examples_for "The user is not the owner of a profile page" do
      it "redirects to the home page" do
        get 'show', :id => @person.to_param
        response.should redirect_to(root_path)
      end

      it "displays a flash error message" do
        get 'show', :id => @person.to_param
        flash[:notice].should == "You don't have permission to see this page"
      end
    end

    describe "when logged in as the user" do
      before :each do
        @user = Factory.create(:user, :login => 'testThis')
        login_as(@user)
      end

      describe "when visiting my own page and the page is not public" do
        before(:each) do
          @person = Factory.create(:person, :user => @user, :public_profile => false)
        end

        it_should_behave_like "The user is the owner of a profile page"
      end

      describe "when visiting my own page and the page is public" do
        before(:each) do
          @person = Factory.create(:person, :user => @user, :public_profile => true)
        end

        it_should_behave_like "The user is the owner of a profile page"
      end
    end

    describe "when not logged in as the user" do
      describe "when visiting a profile's page and the page is not public" do
        before(:each) do
          user = Factory.create(:user)
          @person = Factory.create(:person, :user => user, :public_profile => false)
        end

        it_should_behave_like "The user is not the owner of a profile page"
      end

      describe "when visiting a profile's page and the page is public" do
        before(:each) do
          user = Factory.create(:user)
          @person = Factory.create(:person, :user => user, :public_profile => true)
        end

        it_should_behave_like "The user is the owner of a profile page"
      end

      describe "when visiting an anonymous profile page" do
        before(:each) do
          @person = Factory.create(:person, :public_profile => false)
        end

        it_should_behave_like "The user is the owner of a profile page"
      end
    end
  end

  describe "edit" do
    describe "when logged in as a user" do
      before do
        @user = Factory.create(:user)
        login_as(@user)
      end

      describe "when editing my own profile" do
        before :each do
          @person = Factory.create(:person, :user => @user)
        end

        it "should render the edit template" do
          get :edit, :id => @person.to_param
          response.should be_success
          response.should render_template('edit')
        end

        it "should assign the person" do
          get :edit, :id => @person.to_param
          assigns[:person].should == @person
        end
      end

      describe "attempting to edit another user's profile" do
        before :each do
          user2 = Factory.create(:user)
          @person = Factory.create(:person, :user => user2)
        end

        it "should set an error and redirect to root" do
          get :edit, :id => @person.to_param
          response.should redirect_to(root_path)
          flash[:notice].should == "You don't have permission to edit this page"
        end
      end

      describe "editing an anonymous profile" do
        it "needs to be defined"
      end
    end

    describe "when not logged in" do
      before do
        @mock_person = build_mock_person
        @mock_person.stubs(:to_param).returns('some_login')
        controller.stubs(:current_user).returns nil
        Person.stubs(:find_by_param).with('some_login').returns(@mock_person)
      end

      describe "editing an anonymous profile" do
        before :each do
          @person = Factory.create(:person)
        end

        it "should render the edit template" do
          get :edit, :id => @person.to_param
          response.should be_success
          response.should render_template('edit')
        end

        it "should assign the person" do
          get :edit, :id => @person.to_param
          assigns[:person].should == @person
        end
      end

      describe "editing a user's profile" do
        before :each do
          user = Factory.create(:user)
          @person = Factory.create(:person, :user => user)
        end

        it "should set an error and redirect to root" do
          get :edit, :id => @person.to_param
          response.should redirect_to(root_path)
          flash[:notice].should == "You don't have permission to edit this page"
        end
      end
    end
  end

  describe "register" do
    describe "when logged in" do
      before :each do
        @user = Factory.create(:user)
        login_as(@user)
      end

      describe "for my profile" do
        before :each do
          @person = Factory.create(:person, :user => @user)
        end

        it "should redirect to the edit page" do
          get :register, :id => @person.to_param
          response.should redirect_to(edit_person_path(@person))
        end
      end

      describe "for another user's profile" do
        before :each do
          user2 = Factory.create(:user)
          @person = Factory.create(:person, :user => user2)
        end

        it "should set an error and redirect to root" do
          get :register, :id => @person.to_param
          response.should redirect_to(root_path)
          flash[:notice].should == "You don't have permission to edit this page"
        end
      end

      describe "for an anonymous profile" do
        it "needs to be defined"
      end
    end

    describe "when not logged in" do
      describe "for an anonymous profile" do
        before :each do
          @person = Factory.create(:person)
        end

        it "should render the register template" do
          get :register, :id => @person.to_param
          response.should be_success
          response.should render_template('register')
        end

        it "should assign the person" do
          get :register, :id => @person.to_param
          assigns[:person].should == @person
        end
      end

      describe "for another user's profile" do
        before :each do
          user = Factory.create(:user)
          @person = Factory.create(:person, :user => user)
        end

        it "should set an error and redirect to root" do
          get :register, :id => @person.to_param
          response.should redirect_to(root_path)
          flash[:notice].should == "You don't have permission to edit this page"
        end
      end
    end
  end

  describe "update" do
    describe "user with blank password" do
      before(:each) do
        @mock_person = build_mock_person
        controller.stubs(:current_user).returns  @mock_person
        Person.stubs(:find_by_param).returns  @mock_person
        Person.stubs(:find_by_id).returns  @mock_person
        Person.stubs(:find_resource).returns( @mock_person)
      end

      it "fail if user is autogen with empty password and new login" do
        mock_person = @mock_person
        mock_person.stubs(:login_set_by_user?).returns false
        mock_person.stubs(:errors).returns(mock('error', :add))
        mock_person.stubs(:login).returns 'apple'
        mock_person.stubs(:[]=)

        mock_avatar = mock('avatar', :url => 'avatar_url')
        mock_person.stubs(:avatar).returns(mock_avatar)
        mock_person.stubs(:avatar=)
        mock_person.stubs(:attributes=)
        mock_person.stubs(:valid?)

        put(:update, "person" => {"login" => 'gandy', 'email' => 'gandy@post.com'})
      end

      it "doesn't fail if user is autogen with empty password and old login" do
        @mock_person.stubs(:login_set_by_user?).returns false
        mock_error = mock('error')
        mock_error.expects(:add).never.with('Please', " choose a valid password (minimum is 4 characters)")
        @mock_person.stubs(:errors).returns(mock_error)
        @mock_person.stubs(:login).returns 'gandy'

        put(:update, "person" => {"login" => 'gandy', 'email' => 'gandy@post.com', 'password' => ''})
      end

      it "doesn't fail if user is autogen with empty password" do
        @mock_person.stubs(:login_set_by_user?).returns true
        put(:update, "person" => {"login" => 'gandy', 'email' => 'gandy@post.com', 'password' => ''})
      end
    end

    it "doesn't fail if autogen user with filled password" do
      person = Factory(:person, :email => 'gandy@post.com', :login => 'autogen_abcdefgh', :page_code => 'abcdefgh')
      put(:update, "person" => {"login" => 'autogen_abcdefgh', 'email' => 'gandy@post.com', 'passsword' => 'supersecret',  'password_confirmation' => 'supersecret'})
    end

    describe "when logged in as the updated user" do
      before do
        @mock_person = build_mock_person
        controller.stubs(:current_user).returns @mock_person
        Person.stubs(:find_by_param).returns @mock_person
      end

      it "should set the login in a protected way on the updated resource" do
        PeopleController.any_instance.stubs(:password_invalid?).returns false
        mock_person = @mock_person

        mock_person.stubs(:avatar).returns('avatar')
        mock_person.stubs(:avatar=)
        mock_person.expects(:update_attributes)
        mock_person.expects(:protected_login=).with('gandy')

        Person.stubs(:find_by_param).returns mock_person
        put(:update, "person" => {"login" => 'gandy', 'email' => 'gandy@post.com'})
      end

      it "should redirect to the show page" do
        PeopleController.any_instance.stubs(:password_invalid?)
        PeopleController.any_instance.stubs(:update_logged_user)
        put(:update, "person" => {"login" => 'gandy', 'password' => 'asdasds'})
        response.should redirect_to(person_path(@mock_person))
      end

      it "should flash a thank you message" do
        PeopleController.any_instance.stubs(:password_invalid?)
        put(:update, "person" => {"login" => 'gandy'})
        flash[:notice].should =~ /thank you/i
      end

      it "find resource only for existed login" do
        nil_person = mock('nil_person')
        nil_person.stubs(:nil?).returns(true)
        Person.stubs(:find_by_param).returns(nil_person)
        mock_person = mock('person')
        ApplicationController.any_instance.stubs(:current_user).returns(mock_person)

        put(:update, "person" => {"login" => 'gandy', 'password' => 'topsecret', 'password_confirmation' => 'topsecret'})
      end
    end

    describe "doesn't update image with invalid validation" do
      before do
        @mock_person = build_mock_person
        controller.stubs(:current_user).returns @mock_person
        Person.stubs(:find_by_param).returns @mock_person
        PeopleController.any_instance.stubs(:password_invalid?).returns(mock)
        PeopleController.any_instance.stubs(:populate_resource).once
        @mock_person.stubs(:update_attributes).returns false
        @mock_person.stubs(:login).returns 'applesmind'
      end

      it "and load previous picture for avatar" do
        mock_person = @mock_person
        mock_avatar = mock('avatar', :url => 'avatar_url')
        mock_person.stubs(:avatar).returns(mock_avatar)
        Person.stubs(:find_by_id).returns mock_person
        mock_person.expects(:avatar=).with(mock_avatar)

        put(:update, "person" => {'login'=>'gandy'})
      end

      it "and set default picture for avatar" do
        mock_person = @mock_person
        mock_person.expects(:avatar).returns(mock('avatar', :url => Person.new.avatar.url))
        Person.stubs(:find_by_id).returns @mock_person
        @mock_person.expects(:avatar=)

        put(:update, "person" => {'login'=>'gandy'})
      end

    end

    describe "udpate logged user and reset the session" do
      before(:each) do
        @person = Factory(:person, :login => 'gandy', 'password' => 'topsecret', 'password_confirmation' => 'topsecret')
        controller.stubs(:current_user).returns @person
        Person.stubs(:find_by_param).returns @person
      end

      it "update user session on update" do
        PeopleController.any_instance.stubs(:password_invalid?).returns false
        controller.expects(:update_logged_user)
        put(:update, "person" => {"login" => 'gandy'})
      end

      it "set new user session if password was updated" do
        UserSession.expects(:create!).once.with(
                    :login => 'gandy',
                    :password => 'topsecret',
                    :password_confirmation => 'topsecret')
        put(:update, "person" => {"login" => 'gandy', 'password' => 'topsecret', 'password_confirmation' => 'topsecret'})
      end
    end

    describe "profile picture" do
      before(:each) do
        @person = Factory(:person, :login => 'gandy', 'password' => 'topsecret', 'password_confirmation' => 'topsecret')
        controller.stubs(:current_user).returns @person
        Person.stubs(:find_by_param).returns @person
        PeopleController.any_instance.stubs(:password_invalid?).returns false
      end

      it "delete if delete_checkbox is in params" do
         PeopleController.any_instance.expects(:delete_profile_picture).once
         put(:update, "person" => {"login" => 'gandy'}, 'delete_avatar' => 1)
      end

      it "don't delete if delete_checkbox is not int params" do
         PeopleController.any_instance.expects(:delete_profile_picture).never
         put(:update, "person" => {"login" => 'gandy'})
      end
    end

    describe "when logged in as a different user as the updated one" do
      before do
        @logged_in_person = build_mock_person
        controller.stubs(:current_user).returns @logged_in_person
        @mock_person = build_mock_person
        Person.stubs(:find_by_param).returns @mock_person
      end

      it "should not update any attributes of the updated user" do
        @mock_person.expects(:update_attributes).never
        put(:update, "person" => {"login" => 'gandy'})
      end

      it "should not update the login of the updated user" do
        @mock_person.expects(:protected_login=).never
        put(:update, "person" => {"login" => 'gandy'})
      end

      it "should set the notice flash" do
        put(:update, "person" => {"login" => 'gandy'})
        flash[:notice].should == 'You do not have permission to edit this page'
      end

      it "should redirect to the login page" do
        put(:update, "person" => {"login" => 'gandy'})
        response.should redirect_to(root_path)
      end
    end
  end

  describe "new" do
    it "should render the new template" do
      get :new
      response.should be_success
      response.should render_template('new')
    end

    it "should assign a new person with mindapples" do
      Person.expects(:new_with_mindapples).returns(:person_with_mindapples)
      get :new
      assigns[:person].should == :person_with_mindapples
    end

    context "handling network" do
      it "sets @network to nil if no network is passed" do
        get :new
        assigns[:network].should be_nil
      end

      it "sets @network to the network if a known one is passed" do
        network = Factory.create(:network)
        get :new, :network => network.url
        assigns[:network].should == network
      end

      it "renders a 404 if an unknown network is passed" do
        get :new, :network => "froob"
        response.code.should == "404"
        response.should render_template('errors/error_404')
      end
    end

    context "when logged in" do
      it "needs to be defined"
    end
  end

  describe "create" do
    context "with valid params" do
      def do_create(params = {})
        post :create, :person => {"policy_checked" => "1"}.merge(params)
      end

      it "should create a new person" do
        lambda do
          do_create
        end.should change(Person, :count).by(1)
        Person.last.policy_checked.should == true
      end

      it "should redirect to the register page" do
        do_create
        person = Person.last
        response.should redirect_to(register_person_path(person))
      end

      it "should add the network_id to the person if network_url param passed" do
        network = Factory.create(:network, :url => 'wibble')
        do_create "network_url" => 'wibble'
        Person.last.network_id.should == network.id
      end

      it "should ignore the network_url param if no matching network is found" do
        do_create "network_url" => 'wibble'
        Person.last.network_id.should == nil
      end
    end

    context "with invalid params" do
      def do_create(params = {})
        post :create, :person => {"policy_checked" => "0", "name" => "fooey"}.merge(params)
      end

      it "should not create a person" do
        lambda do
          do_create
        end.should_not change(Person, :count)
      end

      it "should re-render the edit template assigning the invalid person" do
        do_create
        response.should render_template('edit')
        assigns[:person].policy_checked.should == false
        assigns[:person].name.should == "fooey"
      end

      it "should assign the network if network_url param is passed" do
        network = Factory.create(:network, :url => 'wibble')
        do_create "network_url" => 'wibble'
        assigns[:network].should == network
      end

      it "should ignore the network_url param if no matching network is found" do
        do_create "network_url" => 'wibble'
        assigns[:network].should == nil
      end
    end

    it "should not allow a constructed form to create more than five mindapples" do
      post(:create, "person" =>
           {
             "mindapples_attributes" =>
             {
               "0" => {"suggestion" => "apple"},
               "1" => {"suggestion" => "banana"},
               "2" => {"suggestion" => "coconut"},
               "3" => {"suggestion" => "date"},
               "4" => {"suggestion" => "elderberry"},
               "5" => {"suggestion" => "fig"}
             }
           })
      controller.resource.mindapples.size.should == 5
    end

    it "does not use the role field if passed as a param" do
      post :create, "person" => {'name' => 'bigapple', "role" => "admin"} 
      assigns[:person].role.should be_nil
    end
  end

  describe "like mindapples actions" do

    before(:each) do
      @person = Factory.create(:person, :email => "abcdef@ghijk.com")
      @owned_mindapple = Factory.create(:mindapple)
      @others_mindapple = Factory.create(:mindapple)

      @person.mindapples << @owned_mindapple
    end

    describe "like" do
      describe "when logged in" do

        before(:each) do
          @person = Factory.create(:person, :login => 'testThis', :public_profile => false)
          controller.stubs(:current_user).returns @person
          Person.stubs(:find_by_param).returns(@person)
        end

        it "should be successful" do
          mindapple = Factory.create(:mindapple)
          put :likes, :id => mindapple

          response.should be_success
        end

        it "adds a mindapple as liked by a user only if the user is not the owner" do
          mindapple = Factory.create(:mindapple)
          put :likes, :id => mindapple

          @person.liked_mindapples.size.should == 1
        end

        it "doesn't add a mindapple more than once" do
          mindapple = Factory.create(:mindapple)
          @person.liked_mindapples << mindapple

          put :likes, :id => mindapple

          @person.liked_mindapples.size.should == 1
        end

        it "redirects to the homepage if trying to add a mindapple more than once" do
          mindapple = Factory.create(:mindapple)
          @person.liked_mindapples << mindapple

          put :likes, :id => mindapple
          response.should redirect_to(root_path)
        end

        it "shows an error message if trying to add a mindapple more than once" do
          mindapple = Factory.create(:mindapple)
          @person.liked_mindapples << mindapple

          put :likes, :id => mindapple

          flash[:notice].should == "You can't like a mindapple more than once"
        end

        it "doesn't add a mindapple to a user's liked ones if the user is the owner of the mindapple" do
          mindapple = Factory.create(:mindapple)
          @person.mindapples << mindapple
          put :likes, :id => mindapple

          @person.liked_mindapples.should_not include(mindapple)
        end

        it "redirects to the homepage if the user tries to like one of its mindapples" do
          mindapple = Factory.create(:mindapple)
          @person.mindapples << mindapple
          put :likes, :id => mindapple

          response.should redirect_to(root_path)
        end

        it "shows an error message if the user tries to like one of its mindapples" do
          mindapple = Factory.create(:mindapple)
          @person.mindapples << mindapple
          put :likes, :id => mindapple

          flash[:notice].should == "Sorry, you can't like one of your own mindapples"
        end

        it "doesn't add a mindapple if it doesn't exist" do
          put :likes, :id => -1

          @person.liked_mindapples.should be_empty
        end

        it "redirects to the homepage if trying to add a mindapple that doesn't exist" do
          put :likes, :id => -1

          response.should redirect_to(root_path)
        end

        it "shows an error message if trying to add a mindapple that doesn't exist" do
          put :likes, :id => -1

          flash[:notice].should == "Unknown mindapple, couldn't finish the operation"
        end

      end

      describe "when not logged in" do
        before(:each) do
          @person = Factory.create(:person, :login => 'testThis', :public_profile => false)
          @person.stubs(:to_param).returns('testThis')
          controller.stubs(:current_user).returns nil
          Person.stubs(:find_by_param).with('testThis').returns(@person)
        end

        it "redirects to the homepage" do
          mindapple = Factory.create(:mindapple)
          put :likes, :mindapple => mindapple

          response.should redirect_to(root_path)
        end

        it "shows an error message" do
          mindapple = Factory.create(:mindapple)
          put :likes, :mindapple => mindapple

          flash[:notice].should == "You must be logged in to like a mindapple"
        end

        it "doesn't add a mindapple as liked by a user that doesn't own the mindapple" do
          mindapple = Factory.create(:mindapple)
          put :likes, :mindapple => mindapple

          @person.liked_mindapples.should be_empty
        end

        it "doesn't add a mindapple to a user's liked ones when the user owns the mindapple" do
          mindapple = Factory.create(:mindapple)
          @person.mindapples << mindapple
          put :likes, :mindapple => mindapple

          @person.liked_mindapples.should_not include(mindapple)
        end

        it "doesn't add a mindapple if it doesn't exist" do
          put :likes, :mindapple => -1

          @person.liked_mindapples.should be_empty
        end

      end

    end

    describe "unlike" do
      describe "when logged in" do

        before(:each) do
          @person = Factory.create(:person, :login => 'testThis', :public_profile => false)
          controller.stubs(:current_user).returns @person
          Person.stubs(:find_by_param).returns(@person)
        end

        # it "should be successful" do
        #   mindapple = Factory.create(:mindapple)
        #   put :unlikes, :id => mindapple
        #
        #   response.should be_success
        # end

        it "removes a mindapple from a user's liked_mindapples only if the user previously liked it" do
          mindapple = Factory.create(:mindapple)
          @person.liked_mindapples << mindapple

          put :unlikes, :id => mindapple

          @person.liked_mindapples.should_not include(mindapple)
        end

        it "doesn't do anything  if the user didn't previously like it" do
          mindapple = Factory.create(:mindapple)

          put :unlikes, :id => mindapple

          @person.liked_mindapples.should be_empty
        end

        it "redirects to the homepage if the user didn't previously like it" do
          mindapple = Factory.create(:mindapple)

          put :unlikes, :id => mindapple

          response.should redirect_to(root_path)
        end

        it "shows an error message if the user didn't previously like it" do
          mindapple = Factory.create(:mindapple)

          put :unlikes, :id => mindapple

          flash[:notice].should == "You need to like a mindapple first before you can unlike it!"
        end

        it "doesn't remove a mindapple from another user's liked_mindapples" do
          mindapple = Factory.create(:mindapple)
          another_person = Factory.create(:person, :email => "emailTestEmail@email.com")

          another_person.liked_mindapples << mindapple

          put :unlikes, :id => mindapple

          another_person.liked_mindapples.size.should == 1
        end

        it "redirects to the homepage if trying to unlike another's liked_mindapples" do
          mindapple = Factory.create(:mindapple)
          another_person = Factory.create(:person, :email => "newEmailTestEmail@email.com")

          another_person.liked_mindapples << mindapple

          put :unlikes, :id => mindapple

          response.should redirect_to(root_path)
        end
      end

      describe "when not logged in" do
        before(:each) do
          @person = Factory.create(:person, :login => 'testThis', :public_profile => false)
          @person.stubs(:to_param).returns('testThis')
          controller.stubs(:current_user).returns nil
          Person.stubs(:find_by_param).with('testThis').returns(@person)
        end

        it "redirects to the homepage" do
          mindapple = Factory.create(:mindapple)
          put :unlikes, :id => mindapple

          response.should redirect_to(root_path)
        end

        it "doesn't remove a mindapple from a user's liked_mindapples if the user previously liked it" do
          mindapple = Factory.create(:mindapple)
          @person.liked_mindapples << mindapple

          put :unlikes, :id => mindapple

          @person.liked_mindapples.should include(mindapple)
        end

        it "doesn't do anything  if the user didn't previously like it" do
          mindapple = Factory.create(:mindapple)

          put :unlikes, :id => mindapple

          @person.liked_mindapples.should be_empty
        end

        it "doesn't remove a mindapple from another user's liked_mindapples" do
          mindapple = Factory.create(:mindapple)
          another_person = Factory.create(:person, :email => "stset@email.com")

          another_person.liked_mindapples << mindapple

          put :unlikes, :id => mindapple

          another_person.liked_mindapples.size.should == 1
        end

        it "shows a error message" do
          mindapple = Factory.create(:mindapple)
          put :unlikes, :id => mindapple

          flash[:notice].should == "You must be logged in to unlike a mindapple"
        end
      end

    end
  end

  describe "favourites" do
    it "should return the favourites in @favourites" do
      person = Factory.create(:person, :email => "e@mail.com", :login => 'login_test')
      mindapple_1 = Factory.create(:mindapple)
      mindapple_2 = Factory.create(:mindapple)
      person.liked_mindapples << mindapple_1
      person.liked_mindapples << mindapple_2

      get :favourites, :id => person.login

      assigns[:favourites].size.should == person.liked_mindapples.size
    end
  end
  
  describe "find_resource" do
    it "should cache the result" do
      person = Factory.create(:person)
      controller.stubs(:params).returns({"id" => person.to_param})
      controller.send(:find_resource)
      Person.expects(:find_by_param!).never
      controller.send(:find_resource)
    end

    it "always returns the found resource" do
      person = Factory.create(:person)
      controller.stubs(:params).returns({"id" => person.to_param})
      controller.send(:find_resource)
      controller.send(:find_resource).should == person
    end
  end
end
