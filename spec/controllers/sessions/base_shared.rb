require 'spec_helper'

shared_examples "a session controller" do

  controller do
    def send_action method_name, *args
      params[:puffer] = Puffer::Resource::Node.new(nil, :name => :anonymous, :controller => self.class, :singular => false)
      send method_name, *args
    end
  end

  describe "GET new" do
    it "assigns @record" do
      get :new
      assigns(:record).should be_a_new controller.model
    end

    it "renders the new template" do
      get :new
      response.should render_template
    end
  end

  describe "POST create" do
    it "with invalid data" do
      post :create, param_key => {:email => user.email, :password => '111'}
      response.should render_template 'new'
    end

    it "assigns @record with invalid data" do
      post :create, param_key => {:email => user.email, :password => '111'}
      assigns(:record).should be_a_new controller.model
    end

    it "with valid data" do
      post :create, param_key => {:email => user.email, :password => '123456'}
      response.should redirect_to '/admin'
    end

    it "with valid data and return_to" do
      return_to = "/hello/world"

      post :create, param_key => {:email => user.email, :password => '123456'}, :return_to => return_to
      response.should redirect_to return_to
    end

    it "current_puffer_user shoul be set" do
      post :create, param_key => {:email => user.email, :password => '123456'}
      controller.current_puffer_user.should == user
    end
  end

  describe "DELETE destroy" do
    it "current_puffer_user shoul be nil" do
      delete :destroy, :id => 42
      controller.current_puffer_user.should be_nil
    end

    it "should redirect" do
      delete :destroy, :id => 42
      response.should redirect_to '/admin/session/new'
    end
  end

end