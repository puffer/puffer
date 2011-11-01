require 'spec_helper'

describe "Field" do

  it "#model" do
    field = Puffer::Field.new 'user.profile.name', Post
    field.model.should == Profile
    field = Puffer::Field.new 'user.email', Post
    field.model.should == User
    field = Puffer::Field.new 'user', Post
    field.model.should == Post
    field = Puffer::Field.new 'title', Post
    field.model.should == Post
  end

  it "#name" do
    field = Puffer::Field.new 'user.profile.name', Post
    field.name.should == 'name'
  end

  it "#column" do
    field = Puffer::Field.new 'user.profile.name', Post
    field.name.should == 'name'
    field = Puffer::Field.new 'user.full_name', Post
    field.column.should == nil
  end

  it '#type' do
    field = Puffer::Field.new 'user.created_at', Post
    field.type.should == :datetime
  end

  it '#type with virtual field' do
    field = Puffer::Field.new 'user.full_name', Post
    field.type.should == :string
  end

  it '#type was specified' do
    field = Puffer::Field.new 'user.full_name', Post, :type => :text
    field.type.should == :text
  end

end
