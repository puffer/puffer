module Puffer
  class Engine < Rails::Engine
    config.paths.add 'app/components', :eager_load => true
    config.autoload_paths << File.join(root, 'lib')

    initializer "puffer.add_view_paths", :after => :add_view_paths do |app|
      Puffer::Component::Base.view_paths = paths["app/components"].existent
    end
  end
end
