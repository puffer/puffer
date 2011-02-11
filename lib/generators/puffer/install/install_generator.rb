class Puffer::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def generate_assets
    directory 'puffer', 'public/puffer'
  end

  def generate_config
    copy_file 'puffer.rb', 'config/initializers/puffer.rb'
  end

  def generate_puffer_controllers
    copy_file 'sessions_controller.rb', 'app/controllers/puffer/sessions_controller.rb'
    copy_file 'dashboard_controller.rb', 'app/controllers/puffer/dashboard_controller.rb'
  end

  def generate_routes
    route "namespace :puffer do\n    root :to => 'dashboard#index'\n    resource :session\n  end"
  end

end
