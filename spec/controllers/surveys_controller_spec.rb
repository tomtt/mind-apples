require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SurveysController do

  def mock_survey(stubs={})
    @mock_survey ||= mock_model(Survey, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all surveys as @surveys" do
      Survey.should_receive(:find).with(:all).and_return([mock_survey])
      get :index
      assigns[:surveys].should == [mock_survey]
    end

    describe "with mime type of xml" do
  
      it "should render all surveys as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Survey.should_receive(:find).with(:all).and_return(surveys = mock("Array of Surveys"))
        surveys.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested survey as @survey" do
      Survey.should_receive(:find).with("37").and_return(mock_survey)
      get :show, :id => "37"
      assigns[:survey].should equal(mock_survey)
    end
    
    describe "with mime type of xml" do

      it "should render the requested survey as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Survey.should_receive(:find).with("37").and_return(mock_survey)
        mock_survey.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new survey as @survey" do
      Survey.should_receive(:new).and_return(mock_survey)
      get :new
      assigns[:survey].should equal(mock_survey)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested survey as @survey" do
      Survey.should_receive(:find).with("37").and_return(mock_survey)
      get :edit, :id => "37"
      assigns[:survey].should equal(mock_survey)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created survey as @survey" do
        Survey.should_receive(:new).with({'these' => 'params'}).and_return(mock_survey(:save => true))
        post :create, :survey => {:these => 'params'}
        assigns(:survey).should equal(mock_survey)
      end

      it "should redirect to the created survey" do
        Survey.stub!(:new).and_return(mock_survey(:save => true))
        post :create, :survey => {}
        response.should redirect_to(survey_url(mock_survey))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved survey as @survey" do
        Survey.stub!(:new).with({'these' => 'params'}).and_return(mock_survey(:save => false))
        post :create, :survey => {:these => 'params'}
        assigns(:survey).should equal(mock_survey)
      end

      it "should re-render the 'new' template" do
        Survey.stub!(:new).and_return(mock_survey(:save => false))
        post :create, :survey => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested survey" do
        Survey.should_receive(:find).with("37").and_return(mock_survey)
        mock_survey.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :survey => {:these => 'params'}
      end

      it "should expose the requested survey as @survey" do
        Survey.stub!(:find).and_return(mock_survey(:update_attributes => true))
        put :update, :id => "1"
        assigns(:survey).should equal(mock_survey)
      end

      it "should redirect to the survey" do
        Survey.stub!(:find).and_return(mock_survey(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(survey_url(mock_survey))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested survey" do
        Survey.should_receive(:find).with("37").and_return(mock_survey)
        mock_survey.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :survey => {:these => 'params'}
      end

      it "should expose the survey as @survey" do
        Survey.stub!(:find).and_return(mock_survey(:update_attributes => false))
        put :update, :id => "1"
        assigns(:survey).should equal(mock_survey)
      end

      it "should re-render the 'edit' template" do
        Survey.stub!(:find).and_return(mock_survey(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested survey" do
      Survey.should_receive(:find).with("37").and_return(mock_survey)
      mock_survey.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the surveys list" do
      Survey.stub!(:find).and_return(mock_survey(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(surveys_url)
    end

  end

end
