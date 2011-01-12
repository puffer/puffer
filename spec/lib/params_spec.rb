require 'spec_helper'

describe "Params" do

  include RSpec::Rails::RoutingExampleGroup

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

  describe "GET /admin/users" do
    it "should set proper params" do
      assert_recognizes({"ancestors"=>[],
        "action"=>"index",
        "plural"=>true,
        "controller"=>"admin/users",
        "children"=>[:profile, :posts]}, '/admin/users')
    end
  end

  describe "GET /admin/users/1/profile" do
    it "should set proper params" do
      assert_recognizes({"ancestors"=>[:users],
        "action"=>"show",
        "user_id"=>"1",
        "plural"=>false,
        "controller"=>"admin/profiles",
        "children"=>[:tags]}, '/admin/users/1/profile')
    end
  end

  describe "get /admin/users/1/posts" do
    it "should set proper params" do
      assert_recognizes({"ancestors"=>[:users],
        "action"=>"index",
        "user_id"=>"1",
        "plural"=>true,
        "controller"=>"admin/posts",
        "children"=>[:categories, :tags]}, '/admin/users/1/posts')
    end
  end

  describe "GET /admin/users/1/posts/1/categories" do
    it "should set proper params" do
      assert_recognizes({"ancestors"=>[:users, :posts],
        "action"=>"index",
        "post_id"=>"1",
        "user_id"=>"1",
        "plural"=>true,
        "controller"=>"admin/categories",
        "children"=>[]}, '/admin/users/1/posts/1/categories')
    end
  end

  describe "GET /admin/profiles" do
    it "should set proper params" do
      assert_recognizes({"ancestors"=>[],
        "action"=>"index",
        "plural"=>true,
        "controller"=>"admin/profiles",
        "children"=>[:tags]}, '/admin/profiles')
    end
  end

  describe "GET /admin/posts" do
    it "should set proper params" do
      assert_recognizes({"ancestors"=>[],
        "action"=>"index",
        "plural"=>true,
        "controller"=>"admin/posts",
        "children"=>[:user, :categories]}, '/admin/posts')
    end
  end

  describe "GET /admin/posts/1/categories" do
    it "should set proper params" do
      assert_recognizes({"ancestors"=>[:posts],
        "action"=>"index",
        "post_id"=>"1",
        "plural"=>true,
        "controller"=>"admin/categories",
        "children"=>[]}, '/admin/posts/1/categories')
    end
  end

  describe "GET /admin/categories" do
    it "should set proper params" do
      assert_recognizes({"ancestors"=>[],
        "action"=>"index",
        "plural"=>true,
        "controller"=>"admin/categories",
        "children"=>[:posts]}, '/admin/categories')
    end
  end

  describe "GET /admin/categories/1/posts" do
    it "should set proper params" do
      assert_recognizes({"ancestors"=>[:categories],
        "action"=>"index",
        "category_id"=>"1",
        "plural"=>true,
        "controller"=>"admin/posts",
        "children"=>[]}, '/admin/categories/1/posts')
    end
  end
end
