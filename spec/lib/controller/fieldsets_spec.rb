require 'spec_helper'

describe "Fieldsets" do

  context 'fieldset define' do
    subject{Class.new(ApplicationController){
      pufferize!

      setup do
        model_name 'Post'
      end

      define_fieldset :index
    }}

    specify{subject.index_fields.should be_a Puffer::Fieldset}
    specify{subject.index_fields.should be_empty}
  end

  context 'fieldset fallbacks' do
    subject{Class.new(ApplicationController){
      pufferize!

      setup do
        model_name 'Post'
      end

      define_fieldset :index
      define_fieldset :show, :fallbacks => :index
    }}

    specify{subject.index_fields.should be_a Puffer::Fieldset}
    specify{subject.index_fields.should be_empty}
    specify{subject.show_fields.should be_a Puffer::Fieldset}
    specify{subject.show_fields.should be_empty}
  end

  context 'fieldset fallbacks' do
    subject{Class.new(ApplicationController){
      pufferize!

      setup do
        model_name 'Post'
      end

      define_fieldset :index
      define_fieldset :show, :fallbacks => :index

      index do
        field :name
      end
    }}

    specify{subject.index_fields.should have(1).item}
    specify{subject.show_fields.should have(1).item}
    specify{subject.index_fields.should == subject.show_fields}
  end

  context 'fieldset inheritance' do
    subject{Class.new(ApplicationController){
      pufferize!

      setup do
        model_name 'Post'
      end

      define_fieldset :index

      index do
        field :name
      end
    }}
    let(:controller){Class.new(subject){
      define_fieldset :show, :fallbacks => :index
    }}

    specify{subject.index_fields.should have(1).item}
    specify{subject.should_not respond_to :show_fields}
    specify{controller.show_fields.should have(1).item}
    specify{subject.index_fields.should == controller.show_fields}
  end

end