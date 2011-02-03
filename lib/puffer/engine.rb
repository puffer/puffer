module Puffer
  class Engine < Rails::Engine
    config.autoload_paths << File.join(root, 'lib')

    initializer 'puffer.add_cells_paths', :after => :add_view_paths do
      require 'cells'
      ::Cell::Base.prepend_view_path(Cells::DEFAULT_VIEW_PATHS.map { |path| File.join(root, path) })
    end
  end
end
