require 'spec_helper'

describe LocalizedComponent do

  model User
  let(:record) { Fabricate :user }

  field :email, :locales => [:ru, :fr, :en], :type => :localized

  before do
    process('form', record)
  end

  it '#permitted_params' do
    component.permitted_params.should == {'email' => [:ru, :fr, :en]}
  end

end
