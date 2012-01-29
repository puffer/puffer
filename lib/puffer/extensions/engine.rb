module Puffer
  module Extensions
    module Rails
      module Engine
        module Configuration
          extend ActiveSupport::Concern

          included do
            alias_method_chain :paths, :components
          end

          def paths_with_components
            @paths ||= begin
              paths = paths_without_components
              paths.add 'app/components', :eager_load => true
              paths
            end
          end
        end

        extend ActiveSupport::Concern

        included do
          initializer :"puffer.add_view_paths", :after => :add_view_paths do |app|
            Puffer::Component::Base.prepend_view_path paths["app/components"].existent if paths["app/components"]
          end
        end
      end
    end
  end
end

Rails::Engine::Configuration.send :include, Puffer::Extensions::Rails::Engine::Configuration
Rails::Engine.send :include, Puffer::Extensions::Rails::Engine