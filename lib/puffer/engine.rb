module Puffer
  class Engine < Rails::Engine
    config.autoload_paths << File.join(root, 'lib')

    initializer 'puffer.add_puffer_namespace_routes', :after => :add_builtin_route do |app|
      app.routes_reloader.paths.unshift File.join(root, 'config/puffer_routes.rb')
    end
  end
end
