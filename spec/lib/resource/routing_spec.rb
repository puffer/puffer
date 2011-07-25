require 'spec_helper'

describe Puffer::Resource do

  include RSpec::Rails::RequestExampleGroup

  it "regular path" do
    @category = Fabricate :category
    @mock_category = mock_model Category, :id => 42

    get admin_category_path(@category)
    resource = Puffer::Resource.new request.params.merge(:controller => 'admin/categories', :action => 'show'), controller

    resource.collection_path.should == admin_categories_path
    resource.member_path.should == admin_category_path(@category)
    resource.member_path(@mock_category).should == admin_category_path(@mock_category)
    resource.new_path.should == new_admin_category_path
    resource.edit_path.should == edit_admin_category_path(@category)
    resource.edit_path(@mock_category).should == edit_admin_category_path(@mock_category)
  end

  it "regular path with plural model name" do
    @news = Fabricate :news
    @mock_news = mock_model News, :id => 42

    get admin_news_path(@news)
    resource = Puffer::Resource.new request.params.merge(:controller => 'admin/news', :action => 'show'), controller

    resource.collection_path.should == admin_news_index_path
    resource.member_path.should == admin_news_path(@news)
    resource.member_path(@mock_news).should == admin_news_path(@mock_news)
    resource.new_path.should == new_admin_news_path
    resource.edit_path.should == edit_admin_news_path(@news)
    resource.edit_path(@mock_news).should == edit_admin_news_path(@mock_news)
  end

  it "plural path" do
    @post = Fabricate :post_with_categories
    @category = @post.categories.first
    @mock_category = mock_model Category, :id => 42

    get admin_post_category_path(@post, @category)
    resource = Puffer::Resource.new request.params.merge(:controller => 'admin/categories', :action => 'show'), controller

    resource.collection_path.should == admin_post_categories_path(@post)
    resource.member_path.should == admin_post_category_path(@post, @category)
    resource.member_path(@mock_category).should == admin_post_category_path(@post, @mock_category)
    resource.new_path.should == new_admin_post_category_path(@post)
    resource.edit_path.should == edit_admin_post_category_path(@post, @category)
    resource.edit_path(@mock_category).should == edit_admin_post_category_path(@post, @mock_category)
  end

  it "singular path" do
    @user = Fabricate :user_with_profile
    @profile = @user.profile

    get admin_user_profile_path(@user)
    resource = Puffer::Resource.new request.params.merge(:controller => 'admin/profiles', :action => 'show'), controller

    resource.collection_path.should == admin_user_profile_path(@user)
    resource.member_path.should == admin_user_profile_path(@user)
    resource.new_path.should == new_admin_user_profile_path(@user)
    resource.edit_path.should == edit_admin_user_profile_path(@user)
  end

  it "singular parent path" do
    @user = Fabricate :user_with_profile_and_tags
    @tag = @user.profile.tags.first
    @mock_tag = mock_model Tag, :id => 42

    get admin_user_profile_tag_path(@user, @tag)
    resource = Puffer::Resource.new request.params.merge(:controller => 'admin/tags', :action => 'show'), controller

    resource.collection_path.should == admin_user_profile_tags_path(@user)
    resource.member_path.should == admin_user_profile_tag_path(@user, @tag)
    resource.member_path(@mock_tag).should == admin_user_profile_tag_path(@user, @mock_tag)
    resource.new_path.should == new_admin_user_profile_tag_path(@user)
    resource.edit_path.should == edit_admin_user_profile_tag_path(@user, @tag)
    resource.edit_path(@mock_tag).should == edit_admin_user_profile_tag_path(@user, @mock_tag)
  end

end
