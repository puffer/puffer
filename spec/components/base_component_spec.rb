require 'spec_helper'

describe BaseComponent do

  let(:record){Fabricate :post}
  field :title

  it '#index' do
    process(:index, record).should == "#{record.title}"
  end

  it '#form' do
    result = process(:form, record)
    result.should have_tag("input[name='post[title]'][type='text'][value='#{record.title}']")
  end

  it '#filter' do
    process(:filter, record).should == ''
  end

  it '#permitted_params' do
    component.permitted_params.should == 'title'
  end

end
