require 'spec_helper'

describe "Fields" do

end

describe "Field" do

  it "#model" do
    field = Puffer::Fields::Field.new Post, 'user.profile.name'
    field.model.should == Profile
    field = Puffer::Fields::Field.new Post, 'user.email'
    field.model.should == User
    field = Puffer::Fields::Field.new Post, 'title'
    field.model.should == Post
  end

  it "#name" do
    field = Puffer::Fields::Field.new Post, 'user.profile.name'
    field.name.should == 'name'
  end

  it "#query_column" do
    field = Puffer::Fields::Field.new Post, 'user.profile.name'
    field.query_column.should == 'profiles.name'
    field = Puffer::Fields::Field.new Post, 'user.email'
    field.query_column.should == 'users.email'
    field = Puffer::Fields::Field.new Post, 'user.full_name'
    field.query_column.should == nil
  end

  it "#column" do
    field = Puffer::Fields::Field.new Post, 'user.profile.name'
    field.column.name.should == 'name'
    field = Puffer::Fields::Field.new Post, 'user.full_name'
    field.column.should == nil
  end

  it '#type' do
    field = Puffer::Fields::Field.new Post, 'user.created_at'
    field.type.should == :datetime
  end

  it '#type with virtual field' do
    field = Puffer::Fields::Field.new Post, 'user.full_name'
    field.type.should == :string
  end

  it '#type was specified' do
    field = Puffer::Fields::Field.new Post, 'user.full_name', :type => :text
    field.type.should == :text
  end

end
