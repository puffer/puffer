require 'spec_helper'

describe "Params" do

  include RSpec::Rails::RequestExampleGroup

=begin
  params_examples = [
    [:admin_users_url, true, [], [:profile, :posts]]
  ]

  params_examples.each do |(url, plural, ancestors, children)|
    describe "GET #{url}" do
      it "should set proper params" do
        get send(url)

        request.params[:plural].should == plural
        request.params[:ancestors].should == ancestors
        request.params[:children].should == children
      end
    end
  end
=end

  before :each do
    @resource = mock(Puffer::Resource, :collection => [], :member => nil, :template => {:nothing => true})
    Puffer::Resource.stub(:new) {@resource}
  end

  describe "GET /admin/users" do
    it "should set proper params" do
      get admin_users_url

      request.params[:plural].should be_true
      request.params[:ancestors].should == []
      request.params[:children].should == [:profile, :posts]
    end
  end

  describe "GET /admin/users/1/profile" do
    it "should set proper params" do
      get admin_user_profile_url(1)

      request.params[:plural].should be_false
      request.params[:ancestors].should == [:users]
      request.params[:children].should == [:tags]
    end
  end

  describe "get /admin/users/1/posts" do
    it "should set proper params" do
      get admin_user_posts_url(1)

      request.params[:plural].should be_true
      request.params[:ancestors].should == [:users]
      request.params[:children].should == [:categories, :tags]
    end
  end

  describe "GET /admin/users/1/posts/1/categories" do
    it "should set proper params" do
      get admin_user_post_categories_url(1, 1)

      request.params[:plural].should be_true
      request.params[:ancestors].should == [:users, :posts]
      request.params[:children].should == []
    end
  end

  describe "GET /profiles" do
    it "should set proper params" do
      get admin_profiles_url

      request.params[:plural].should be_true
      request.params[:ancestors].should == []
      request.params[:children].should == [:tags]
    end
  end

  describe "GET /posts" do
    it "should set proper params" do
      get admin_posts_url

      request.params[:plural].should be_true
      request.params[:ancestors].should == []
      request.params[:children].should == [:user, :categories]
    end
  end

  describe "GET /admin/posts/1/categories" do
    it "should set proper params" do
      get admin_post_categories_url(1)

      request.params[:plural].should be_true
      request.params[:ancestors].should == [:posts]
      request.params[:children].should == []
    end
  end

  describe "GET /categories" do
    it "should set proper params" do
      get admin_categories_url

      request.params[:plural].should be_true
      request.params[:ancestors].should == []
      request.params[:children].should == [:posts]
    end
  end

  describe "GET /admin/categories/1/posts" do
    it "should set proper params" do
      get admin_category_posts_url(1)

      request.params[:plural].should be_true
      request.params[:ancestors].should == [:categories]
      request.params[:children].should == []
    end
  end
end
