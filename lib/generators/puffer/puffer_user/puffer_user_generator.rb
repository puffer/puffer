class Puffer::PufferUserGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  class_option :orm, :desc => 'Orm to be invoked'

  def self.next_migration_number dirname
    next_migration_number = current_migration_number(dirname) + 1
    ActiveRecord::Migration.next_migration_number(next_migration_number)
  end

  source_root File.expand_path('../templates', __FILE__)

  def copy_controller
    copy_file "puffer_users_controller.rb", "app/controllers/admin/puffer_users_controller.rb"
  end

  def copy_model
    case options[:orm]
    when :activerecord then
      copy_file "puffer_user_activerecord.rb", "app/models/puffer_user.rb"
      migration_template "create_puffer_users.rb", "db/migrate/create_puffer_users.rb"
    when :mongoid then
      copy_file "puffer_user_mongoid.rb", "app/models/puffer_user.rb"
    end
  end

  def generate_routes
    route "namespace :admin do\n    resources :puffer_users\n  end"
  end

end
