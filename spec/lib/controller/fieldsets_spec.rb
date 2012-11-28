require 'spec_helper'

describe Puffer::Controller::Fieldsets do
  let(:controller) do
    Class.new(ActionController::Base) do
      include Puffer::Controller::Fieldsets

      define_fieldset :index, :form
      define_fieldset :show, fallback: :index
      define_fieldset :create, :update, fallback: :form
    end
  end

  let(:inherited) do
    Class.new(controller) do
      define_fieldset :tree, fallback: :index
    end
  end

  context '.define_fieldset' do
    context 'base controller' do
      subject { controller._fieldsets }

      its(:fieldset_names) { should =~ [:index, :show, :form, :create, :update] }
      its(:fallbacks) { should == {
        index: [:index],
        show: [:show, :index],
        form: [:form],
        create: [:create, :form],
        update: [:update, :form]
      }.stringify_keys }
    end

    context 'inherited controller' do
      subject { inherited._fieldsets }

      its(:ancestor) { should == controller._fieldsets }
      its(:fieldset_names) { should =~ [:index, :tree, :show, :form, :create, :update] }
      its(:fallbacks) { should == {
        index: [:index],
        tree: [:tree, :index],
        show: [:show, :index],
        form: [:form],
        create: [:create, :form],
        update: [:update, :form]
      }.stringify_keys }
    end
  end

end
