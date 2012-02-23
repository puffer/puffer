require 'spec_helper'

class ActionComponent < Puffer::Component::Base
  def index
    render :text => 'action output'
  end
end

describe Puffer::Component::ExampleGroup do
  let(:group) do
    RSpec::Core::ExampleGroup.describe do
      include Puffer::Component::ExampleGroup
    end
  end

  it "adds :type => :component to the metadata" do
    group.metadata[:type].should eq(:component)
  end
end