require 'spec_helper'

describe ReferencesOneComponent do

  model Post
  let(:record){Fabricate :post}

  field :user

  it '#index' do
    process(:index, record).should == ''
  end

  it '#form' do
    result = process(:form, record)
    result.should have_tag("input[name='post[user_id]'][type='text']")
  end

  it '#permitted_params' do
    component.permitted_params.should == 'user_id'
  end

end
