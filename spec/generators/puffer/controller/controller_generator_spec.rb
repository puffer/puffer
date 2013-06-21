require 'spec_helper'

# Generators are not automatically loaded by Rails
require 'generators/puffer/controller/controller_generator'

describe Puffer::ControllerGenerator do
  before do
    FileUtils.mkdir_p File.join(Dir.tmpdir, 'ammeter', 'config')
    File.open File.join(Dir.tmpdir, 'ammeter', 'config', 'routes.rb'), 'w' do |routes|
      routes.puts "Rails.application.routes.draw do\nend"
    end
  end

  describe 'controller namespaced in admin module added by default' do
    before { run_generator %w(PufferUser)  }

    describe 'app/controllers/admin/puffer_users_controller.rb' do
      subject { file('app/controllers/admin/puffer_users_controller.rb') }
      it { should exist }
      it { should contain "class Admin::PufferUsersController < Puffer::Base" }
      it { should contain "group :puffer_user" }
      it { should_not contain "model_name \"puffer_user\"" }
      it { should contain "# field :id" }
      it { should contain "field :email" }
      it { should contain "field :password" }
      it { should contain "# field :created_at" }
      it { should contain "# field :updated_at" }
    end

    describe 'config/routes.rb' do
      subject { file('config/routes.rb') }
      it { should contain "namespace :admin do" }
      it { should contain "resources :puffer_users" }
    end
  end

  describe 'controller name can be specified' do
    before { run_generator %w(PufferUser -c user)  }

    describe 'app/controllers/admin/users_controller.rb' do
      subject { file('app/controllers/admin/users_controller.rb') }
      it { should exist }
      it { should contain "class Admin::UsersController < Puffer::Base" }
      it { should contain "model_name \"puffer_user\"" }
    end

    describe 'config/routes.rb' do
      subject { file('config/routes.rb') }
      it { should contain "namespace :admin do" }
      it { should contain "resources :users" }
    end
  end

  describe 'controller namespace can be specified' do
    before { run_generator %w(PufferUser -n Seo)  }

    describe 'app/controllers/seo/puffer_users_controller.rb' do
      subject { file('app/controllers/seo/puffer_users_controller.rb') }
      it { should exist }
      it { should contain "class Seo::PufferUsersController < Puffer::Base" }
    end

    describe 'config/routes.rb' do
      subject { file('config/routes.rb') }
      it { should contain "namespace :seo do" }
      it { should contain "resources :puffer_users" }
    end
  end

  describe 'controller name and namespace together' do
    before { run_generator %w(PufferUser -n seo -c user)  }

    describe 'app/controllers/seo/users_controller.rb' do
      subject { file('app/controllers/seo/users_controller.rb') }
      it { should exist }
      it { should contain "class Seo::UsersController < Puffer::Base" }
      it { should contain "model_name \"puffer_user\"" }
    end

    describe 'config/routes.rb' do
      subject { file('config/routes.rb') }
      it { should contain "namespace :seo do" }
      it { should contain "resources :users" }
    end
  end

  describe 'no controller namespace' do
    before { run_generator %w(PufferUser --no-namespace)  }

    describe 'app/controllers/puffer_users_controller.rb' do
      subject { file('app/controllers/puffer_users_controller.rb') }
      it { should exist }
      it { should contain "class PufferUsersController < Puffer::Base" }
    end

    describe 'config/routes.rb' do
      subject { file('config/routes.rb') }
      it { should_not contain "namespace" }
      it { should contain "resources :puffer_users" }
    end
  end

  describe 'namespaced model' do
    before { run_generator %w(MongoidOrm::Primal)  }

    describe 'app/controllers/admin/primals_controller.rb' do
      subject { file('app/controllers/admin/primals_controller.rb') }
      it { should exist }
      it { should contain "class Admin::PrimalsController < Puffer::Base" }
      it { should contain "group :mongoid_orm" }
      it { should contain "model_name \"mongoid_orm/primal\"" }
    end

    describe 'config/routes.rb' do
      subject { file('config/routes.rb') }
      it { should contain "namespace :admin do" }
      it { should contain "resources :primals" }
    end
  end
end
