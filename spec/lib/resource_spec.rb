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

    before do
      @post = Fabricate :post_with_categories
      @user = Fabricate :user_with_profile_and_tags
    end

    it "no parent" do
      resource = Puffer::Resource.new default_params
      resource.collection.should == Category.limit(25).all
    end

    it "plural parent" do
      resource = Puffer::Resource.new default_params.merge(:ancestors => [:posts], :post_id => @post.id)
      resource.collection.should == @post.categories.limit(25).all
    end

    it "singular parent" do
      resource = Puffer::Resource.new default_params.merge(:controller => 'admin/tags', :ancestors => [:users, :profile], :user_id => @user.id)
      resource.collection.should == @user.profile.tags.limit(25).all
    end

  end

  describe "#member" do

    before do
      @post = Fabricate :post_with_categories
      @category = Fabricate :category
      @user = Fabricate :user_with_profile_and_tags
    end

    it "no parent" do
      resource = Puffer::Resource.new default_params.merge(:id => @category.id)
      resource.member.should == @category
    end

    it "plural parent" do
      resource = Puffer::Resource.new default_params.merge(:ancestors => [:posts], :post_id => @post.id, :id => @post.categories.first.id)
      resource.member.should == @post.categories.first
    end

    it "singular" do
      resource = Puffer::Resource.new default_params.merge(:controller => 'admin/profiles', :plural => false, :ancestors => [:users], :user_id => @user.id)
      resource.member.should == @user.profile
    end

    it "singular parent" do
      resource = Puffer::Resource.new default_params.merge(:controller => 'admin/tags', :ancestors => [:users, :profile], :user_id => @user.id, :id => @user.profile.tags.first.id)
      resource.member.should == @user.profile.tags.first
    end

  end

  describe "#new_member" do

    before do
      @post = Fabricate :post_with_categories
      @user = Fabricate :user_with_profile_and_tags
    end

    it "no parent" do
      resource = Puffer::Resource.new default_params
      resource.new_member.should be_new_record
      resource.new_member.should be_instance_of(Category)
    end

    it "no parent with attributes" do
      resource = Puffer::Resource.new default_params.merge(:category => {:title => 'my new title'})
      resource.new_member.should be_new_record
      resource.new_member.should be_instance_of(Category)
      resource.new_member.title.should == 'my new title'
    end

    it "plural parent" do
      resource = Puffer::Resource.new default_params.merge(:ancestors => [:posts], :post_id => @post.id)
      resource.new_member.should be_new_record
      resource.new_member.should be_instance_of(Category)
    end

    it "plural parent with attributes" do
      resource = Puffer::Resource.new default_params.merge(:ancestors => [:posts], :post_id => @post.id, :category => {:title => 'my new title'})
      resource.new_member.should be_new_record
      resource.new_member.should be_instance_of(Category)
      resource.new_member.title.should == 'my new title'
    end

    it "singular" do
      resource = Puffer::Resource.new default_params.merge(:controller => 'admin/profiles', :plural => false, :ancestors => [:users], :user_id => @user.id)
      resource.new_member.should be_new_record
      resource.new_member.should be_instance_of(Profile)
    end

    it "singular with attributes" do
      resource = Puffer::Resource.new default_params.merge(:controller => 'admin/profiles', :plural => false, :ancestors => [:users], :user_id => @user.id, :profile => {:name => 'my new name'})
      resource.new_member.should be_new_record
      resource.new_member.should be_instance_of(Profile)
      resource.new_member.name.should == 'my new name'
    end

    it "singular parent" do
      resource = Puffer::Resource.new default_params.merge(:controller => 'admin/tags', :ancestors => [:users, :profile], :user_id => @user.id)
      resource.new_member.should be_new_record
      resource.new_member.should be_instance_of(Tag)
    end

    it "singular parent with attributes" do
      resource = Puffer::Resource.new default_params.merge(:controller => 'admin/tags', :ancestors => [:users, :profile], :user_id => @user.id, :tag => {:name => 'my new name'})
      resource.new_member.should be_new_record
      resource.new_member.should be_instance_of(Tag)
      resource.new_member.name.should == 'my new name'
    end

  end

end
