require 'spec_helper'

describe Puffer::Resource do

  def default_params
    ActiveSupport::HashWithIndifferentAccess.new(:controller => 'admin/categories', :action => 'index', :plural => true, :ancestors => [], :children => [])
  end

  def plain_params
    ActiveSupport::HashWithIndifferentAccess.new(:plural => true, :ancestors => [], :children => [])
  end

  it "no tree" do
    resource = Puffer::Resource.new default_params
    resource.parent.should be_nil
    resource.children.should be_empty
  end

  it "full tree" do
    resource = Puffer::Resource.new default_params.merge(:ancestors => [:posts], :children => [:users, :posts])
    resource.parent.should_not be_nil
    resource.ancestors.count.should == 1
    resource.children.count.should == 2
  end

  describe "#parent" do

    it "common params" do
      resource = Puffer::Resource.new default_params.merge(:ancestors => [:users, :posts], :user_id => 37, :post_id => 42)
      parent = resource.parent

      parent.params.should == plain_params.merge(:ancestors => [:users], :user_id => 37, :id => 42)
      parent.controller_name.should == 'posts'
    end

  end

  describe "#children" do

    it "common params" do
      resource = Puffer::Resource.new default_params.merge(:controller => 'admin/posts', :ancestors => [:users], :children => [:categories], :user_id => 37)
      child = resource.children.first

      child.params.should == plain_params.merge(:ancestors => [:users, :posts], :user_id => 37)
      child.controller_name.should == 'categories'
    end

    it "plural params" do
      resource = Puffer::Resource.new default_params.merge(:controller => 'admin/users', :children => [:profile])
      child = resource.children.first

      child.params.should == plain_params.merge(:ancestors => [:users], :plural => false)
      child.controller_name.should == 'profiles'
    end

    it "params with :id" do
      resource = Puffer::Resource.new default_params.merge(:controller => 'admin/posts', :ancestors => [:users], :children => [:categories], :user_id => 37, :id => 42)
      child = resource.children.first

      child.params.should == plain_params.merge(:ancestors => [:users, :posts], :user_id => 37, :post_id => 42)
      child.controller_name.should == 'categories'
    end

  end

  describe "#collection" do

    before :all do
      @post = Fabricate :post_with_categories
      @category = Fabricate :category
      @user = Fabricate :user_with_profile_and_tags
    end

    it "no parent" do
      resource = Puffer::Resource.new default_params

      resource.collection.should == Category.limit(30).all
    end

    it "plural parent" do
      resource = Puffer::Resource.new default_params.merge(:ancestors => [:posts], :post_id => 42)

      Post.stub(:find).with(42) {@post}
      resource.collection.should == @post.categories.limit(30).all
    end

    it "singular parent" do
      resource = Puffer::Resource.new default_params.merge(:controller => 'admin/tags', :ancestors => [:users, :profile], :user_id => 42)

      User.stub(:find).with(42) {@user}
      resource.collection.should == @user.profile.tags.limit(30).all
    end

  end

  describe "#member" do

    before :all do
      @post = Fabricate :post_with_categories
      @category = Fabricate :category
      @user = Fabricate :user_with_profile_and_tags
    end

    it "no parent" do
      resource = Puffer::Resource.new default_params.merge(:id => 42)

      Category.stub(:find).with(42) {@category}
      resource.member.should == @category
    end

    it "plural parent" do
      resource = Puffer::Resource.new default_params.merge(:ancestors => [:posts], :post_id => 42, :id => 37)

      @categories = @post.categories

      Post.stub(:find).with(42) {@post}
      @categories.stub(:find).with(37) {@category}
      resource.member.should == @category
    end

    it "singular" do
      resource = Puffer::Resource.new default_params.merge(:controller => 'admin/profiles', :plural => false, :ancestors => [:users], :user_id => 42)

      @profile = @user.profile

      User.stub(:find).with(42) {@user}
      @user.stub(:profile) {@profile}

      resource.member.should == @profile
    end

    it "singular parent" do
      resource = Puffer::Resource.new default_params.merge(:controller => 'admin/tags', :ancestors => [:users, :profile], :user_id => 42, :id => 37)

      @profile = @user.profile
      @tag = @profile.tags.first

      User.stub(:find).with(42) {@user}
      @user.stub(:profile) {@profile}
      @profile.tags.stub(:find).with(37) {@tag}

      resource.member.should == @tag
    end

  end

  describe "#new_member" do

    before :all do
      @post = Fabricate :post_with_categories
      @category = Fabricate :category
      @user = Fabricate :user_with_profile_and_tags
    end

    it "no parent" do
      resource = Puffer::Resource.new default_params

      Category.stub(:new) {@category}
      resource.new_member.should == @category
    end

    it "plural parent" do
      resource = Puffer::Resource.new default_params.merge(:ancestors => [:posts], :post_id => 42)

      @categories = @post.categories

      Post.stub(:find).with(42) {@post}
      @categories.stub(:new) {@category}
      resource.new_member.should == @category
    end

    it "singular" do
      resource = Puffer::Resource.new default_params.merge(:controller => 'admin/profiles', :plural => false, :ancestors => [:users], :user_id => 42)

      @profile = @user.profile

      User.stub(:find).with(42) {@user}
      @user.stub(:build_profile) {@profile}

      resource.new_member.should == @profile
    end

    it "singular parent" do
      resource = Puffer::Resource.new default_params.merge(:controller => 'admin/tags', :ancestors => [:users, :profile], :user_id => 42)

      @profile = @user.profile
      @tag = @profile.tags.first

      User.stub(:find).with(42) {@user}
      @user.stub(:profile) {@profile}
      @profile.tags.stub(:new) {@tag}

      resource.new_member.should == @tag
    end

  end

end
