module Puffer
  class Engine < Rails::Engine
    config.autoload_paths << File.join(root, 'lib')
  end
end
