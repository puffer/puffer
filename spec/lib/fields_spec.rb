require 'spec_helper'

describe "Field" do

  let(:fieldset){Puffer::Fieldset.new('foo', Post)}

  it "#model" do
    field = fieldset.field 'user.profile.name'
    field.model.should == Profile
    field = fieldset.field 'user.email'
    field.model.should == User
    field = fieldset.field 'user'
    field.model.should == Post
    field = fieldset.field 'title'
    field.model.should == Post
  end

  it "#name" do
    field = fieldset.field 'user.profile.name'
    field.name.should == 'name'
  end

  it "#column" do
    field = fieldset.field 'user.profile.name'
    field.name.should == 'name'
    field = fieldset.field 'user.full_name'
    field.column.should == nil
  end

  it '#type' do
    field = fieldset.field 'user.created_at'
    field.type.should == :datetime
  end

  it '#type with virtual field' do
    field = fieldset.field 'user.full_name'
    field.type.should == :string
  end

  it '#type was specified' do
    field = fieldset.field 'user.full_name', :type => :text
    field.type.should == :text
  end

  it '#type with a custom title' do
    field = fieldset.field 'user.full_name', :title => "Custom title"
    field.human.should == "Custom title"
  end

  it '#type with a default title' do
    field = fieldset.field 'user.full_name'
    field.human.should == "Full name"
  end
end
