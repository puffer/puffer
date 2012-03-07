require 'spec_helper'

# Generators are not automatically loaded by Rails
require 'generators/puffer/controller/controller_generator'

describe Puffer::ControllerGenerator do
  describe 'controller namespaced in admin module added by default' do
    before { run_generator %w(PufferUser)  }

    describe 'app/controllers/admin/puffer_users_controller.rb' do
      subject { file('app/controllers/admin/puffer_users_controller.rb') }
      it { should exist }
      it { should contain "class Admin::PufferUsersController < Puffer::Base" }
      it { should contain "group :puffer_user" }
      it { should contain "# field :id" }
      it { should contain "field :email" }
      it { should contain "field :password" }
      it { should contain "# field :created_at" }
      it { should contain "# field :updated_at" }
    end
  end

  describe 'controller namespace can be specified' do
    before { run_generator %w(PufferUser -n Seo)  }

    describe 'app/controllers/seo/puffer_users_controller.rb' do
      subject { file('app/controllers/seo/puffer_users_controller.rb') }
      it { should exist }
      it { should contain "class Seo::PufferUsersController < Puffer::Base" }
    end
  end

  describe 'no controller namespace' do
    before { run_generator %w(PufferUser --no-namespace)  }

    describe 'app/controllers/puffer_users_controller.rb' do
      subject { file('app/controllers/puffer_users_controller.rb') }
      it { should exist }
      it { should contain "class PufferUsersController < Puffer::Base" }
    end
  end

  describe 'namespaced model' do
    before { run_generator %w(MongoidOrm::Primal)  }

    describe 'app/controllers/admin/primals_controller.rb' do
      subject { file('app/controllers/admin/primals_controller.rb') }
      it { should exist }
      it { should contain "class Admin::PrimalsController < Puffer::Base" }
      it { should contain "group :mongoid_orm" }
    end
  end
end
