require 'spec_helper'

describe NestedAttributesManyComponent do

  model User

  field :posts do
    field :title
    field :body
  end

  it '#permitted_params' do
    component.permitted_params.should == {'posts_attributes' => [:id, :_destroy, 'title', 'body']}
  end

end
