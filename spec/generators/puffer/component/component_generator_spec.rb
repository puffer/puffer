require 'spec_helper'

# Generators are not automatically loaded by Rails
require 'generators/puffer/component/component_generator'

describe Puffer::ComponentGenerator do
  before { run_generator %w(password)  }

  describe 'app/components/password_component.rb' do
    subject { file('app/components/password_component.rb') }
    it { should exist }
    it { should contain "class PasswordComponent < Puffer::Component::Base" }
  end

  describe 'app/components/password/index.html.erb' do
    subject { file('app/components/password/index.html.erb') }
    it { should exist }
    it { should contain "# I'm index" }
  end

  describe 'app/components/password/form.html.erb' do
    subject { file('app/components/password/form.html.erb') }
    it { should exist }
    it { should contain "# I'm form" }
  end

  describe 'app/components/password/filter.html.erb' do
    subject { file('app/components/password/filter.html.erb') }
    it { should exist }
    it { should contain "# I'm filter" }
  end
end
