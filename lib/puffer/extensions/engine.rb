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
          initializer :add_components_paths do |app|
            components = paths["app/components"].existent
            ActiveSupport.on_load(:puffer_component){ prepend_view_path(components) } if components.present?
          end
        end
      end
    end
  end
end

Rails::Engine::Configuration.send :include, Puffer::Extensions::Rails::Engine::Configuration
Rails::Engine.send :include, Puffer::Extensions::Rails::Engine