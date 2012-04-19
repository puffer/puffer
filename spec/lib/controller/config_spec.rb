require 'spec_helper'

describe Puffer::Controller::Config do
  context 'default values' do
    subject{Class.new(ApplicationController) do
      include Puffer::Controller::Config
      puffer_class_attribute :key, :value
    end}
    specify{subject.configuration.key.should == :value}
  end

  context 'redefined values' do
    subject{Class.new(ApplicationController) do
      include Puffer::Controller::Config
      puffer_class_attribute :key, :value

      setup do
        key :value2
      end
    end}
    specify{subject.configuration.key.should == :value2}
  end

  context 'value block' do
    subject{Class.new(ApplicationController) do
      include Puffer::Controller::Config
      puffer_class_attribute :key, :value

      setup do
        key{:hello}
      end
    end}
    specify{subject.configuration.key.should == :hello}
  end

  context 'value proc' do
    subject{Class.new(ApplicationController) do
      include Puffer::Controller::Config
      puffer_class_attribute :key, :value

      setup do
        key lambda{:world}
      end
    end}
    specify{subject.configuration.key.should == :world}
  end
end