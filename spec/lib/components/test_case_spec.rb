require 'spec_helper'

class ActionComponent < Puffer::Component::Base
  def index
    render :text => 'action output'
  end
end

describe ActionComponent do
  include Puffer::Component::TestCase::Behavior

  self.component_class = ActionComponent

  context do
    specify{component.should be_nil}
  end

  context do
    field :foo
    specify{component.should be_a(ActionComponent)}
    specify{component.field.should == _field}
    specify{process(:index, mock_model('Model')).should == 'action output'}
  end
end
