require 'spec_helper'

describe Puffer::Resource do

  include RSpec::Rails::RequestExampleGroup

  it "regular path" do
    @category = Fabricate :category
    @mock_category = mock_model Category, :id => 42

    get admin_category_path(@category)
    resource = Puffer::Resource.new request.params.merge(:controller => 'admin/categories', :action => 'show'), request

    resource.index_path.should == admin_categories_path
    resource.path.should == admin_category_path(@category)
    resource.path(@mock_category).should == admin_category_path(@mock_category)
    resource.new_path.should == new_admin_category_path
    resource.edit_path.should == edit_admin_category_path(@category)
    resource.edit_path(@mock_category).should == edit_admin_category_path(@mock_category)
  end

  it "plural path" do
    @post = Fabricate :post_with_categories
    @category = @post.categories.first
    @mock_category = mock_model Category, :id => 42

    get admin_post_category_path(@post, @category)
    resource = Puffer::Resource.new request.params.merge(:controller => 'admin/categories', :action => 'show'), request

    resource.index_path.should == admin_post_categories_path(@post)
    resource.path.should == admin_post_category_path(@post, @category)
    resource.path(@mock_category).should == admin_post_category_path(@post, @mock_category)
    resource.new_path.should == new_admin_post_category_path(@post)
    resource.edit_path.should == edit_admin_post_category_path(@post, @category)
    resource.edit_path(@mock_category).should == edit_admin_post_category_path(@post, @mock_category)
  end

  it "singular path" do
    @user = Fabricate :user_with_profile
    @profile = @user.profile

    get admin_user_profile_path(@user)
    resource = Puffer::Resource.new request.params.merge(:controller => 'admin/profiles', :action => 'show'), request

    resource.index_path.should == admin_user_profile_path(@user)
    resource.path.should == admin_user_profile_path(@user)
    resource.new_path.should == new_admin_user_profile_path(@user)
    resource.edit_path.should == edit_admin_user_profile_path(@user)
  end

  it "singular parent path" do
    @user = Fabricate :user_with_profile_and_tags
    @tag = @user.profile.tags.first
    @mock_tag = mock_model Tag, :id => 42

    get admin_user_profile_tag_path(@user, @tag)
    resource = Puffer::Resource.new request.params.merge(:controller => 'admin/tags', :action => 'show'), request

    resource.index_path.should == admin_user_profile_tags_path(@user)
    resource.path.should == admin_user_profile_tag_path(@user, @tag)
    resource.path(@mock_tag).should == admin_user_profile_tag_path(@user, @mock_tag)
    resource.new_path.should == new_admin_user_profile_tag_path(@user)
    resource.edit_path.should == edit_admin_user_profile_tag_path(@user, @tag)
    resource.edit_path(@mock_tag).should == edit_admin_user_profile_tag_path(@user, @mock_tag)
  end

end
