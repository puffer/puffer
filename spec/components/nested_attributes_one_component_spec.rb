require 'spec_helper'

describe NestedAttributesOneComponent do

  model Post

  field :user do
    field :email
  end

  it '#permitted_params' do
    component.permitted_params.should == {'user_attributes' => [:id, :_destroy, 'email']}
  end

end
