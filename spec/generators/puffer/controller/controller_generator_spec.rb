require 'spec_helper'

# Generators are not automatically loaded by Rails
require 'generators/puffer/controller/controller_generator'

describe Puffer::ControllerGenerator do
  describe 'controller namespaced in admin module added by default' do
    before { run_generator %w(User name:string email:string)  }

    describe 'app/controllers/admin/users_controller.rb' do
      subject { file('app/controllers/admin/users_controller.rb') }
      it { should exist }
      it { should contain "class Admin::UsersController < Puffer::Base" }
      it { should contain "# field :id" }
      it { should contain "field :email" }
      it { should contain "field :password" }
      it { should contain "# field :created_at" }
      it { should contain "# field :updated_at" }
    end
  end

  describe 'controller namespace can be specified in admin module added by default' do
    before { run_generator %w(Moderator::User name:string email:string)  }

    describe 'app/controllers/moderator/users_controller.rb' do
      subject { file('app/controllers/moderator/users_controller.rb') }
      it { should exist }
      it { should contain "class Moderator::UsersController < Puffer::Base" }
    end
  end
end
