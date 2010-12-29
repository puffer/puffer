module Puffer
  class Railtie < Rails::Engine
    config.autoload_paths << File.expand_path("../..", __FILE__)
  end
end
