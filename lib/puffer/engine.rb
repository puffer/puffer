module Puffer
  class Engine < Rails::Engine
    engine_name :puffer

    config.autoload_paths << File.join(root, 'lib')

    initializer 'puffer_components.set_configs', :after => 'action_controller.set_configs' do |app|
      # Puffer::Component::Base.helpers_path = app.config.helpers_paths
      # Puffer::Component::Base.helper :all
    end
  end
end
