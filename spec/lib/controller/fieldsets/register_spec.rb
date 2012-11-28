require 'spec_helper'

describe Puffer::Controller::Fieldsets::Register do
  let(:fieldset) { double Puffer::Controller::Fieldsets::Fieldset }
  subject { described_class.new }

  describe '.new' do
    its(:ancestor) { should be_nil }
    its(:fieldsets) { should be_a HashWithIndifferentAccess }
    its(:fieldsets) { should be_blank }
    its(:fallbacks) { should be_a HashWithIndifferentAccess }
    its(:fallbacks) { should be_blank }
  end

  describe '#declare' do
    context 'with no fallbacks' do
      before { subject.declare(:index) }

      its(:fieldsets) { should == { 'index' => nil } }
      its(:fallbacks) { should == { 'index' => [:index] } }
    end

    context 'with fallback' do
      before do
        subject.declare(:index)
        subject.declare(:form, fallback: :index)
      end

      its(:fieldsets) { should == { 'index' => nil, 'form' => nil } }
      its(:fallbacks) { should == { 'index' => [:index], 'form' => [:form, :index] } }
    end

    context 'redeclaration' do
      before do
        subject.declare(:form, fallback: :show)
        subject[:form] = fieldset
        subject.declare(:form, fallback: :index)
      end

      its(:fieldsets) { should == { 'form' => fieldset } }
      its(:fallbacks) { should == { 'form' => [:form, :index] } }
    end
  end

  describe '#declared?' do
    before { subject.declare(:index) }

    specify { subject.declared?(:index).should be_true }
    specify { subject.declared?(:form).should be_false }
  end

  describe '#[]' do
    context 'with no fallbacks' do
      before do
        subject.declare(:index)
        subject[:index] = fieldset
      end

      specify { subject[:index].should == fieldset }
      specify { subject[:form].should be_nil }
    end

    context 'with fallback' do
      before do
        subject.declare(:index)
        subject.declare(:form, fallback: :index)
        subject[:index] = fieldset
      end

      specify { subject[:index].should == fieldset }
      specify { subject[:form].should == fieldset }
    end
  end

  describe '#[]=' do
    before do
      subject.declare(:index)
      subject[:index] = fieldset
      subject[:form] = fieldset
    end

    its(:fieldsets) { should == { 'index' => fieldset } }
  end

  describe '#method_missing' do
    context 'fieldset accessors' do
      before do
        subject.declare(:index)
        subject.declare(:form)
        subject[:index] = fieldset
      end

      its(:index) { should == fieldset }
      its(:form) { should be_nil }
      specify { expect { subject.show }.to raise_error(NoMethodError) }
    end

    context 'fieldset mutators' do
      before do
        subject.declare(:index)
        subject.index = fieldset
      end

      its(:index) { should == fieldset }
      specify { expect { subject.form = fieldset }.to raise_error(NoMethodError) }
    end
  end

  describe '#respond_to_missing' do
    before { subject.declare(:index) }

    specify { subject.respond_to?(:index).should be_true }
    specify { subject.respond_to?(:index=).should be_true }
    specify { subject.respond_to?(:form).should be_false }
    specify { subject.respond_to?(:form=).should be_false }
  end

end
