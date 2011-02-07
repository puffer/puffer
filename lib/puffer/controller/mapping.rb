module Puffer
  module Controller
    module Mapping

      def self.included base
        base.class_eval do
          extend ClassMethods
        end
      end

      module ClassMethods

        def index_fields
          _index_fields
        end

        def show_fields
          _show_fields.presence || _index_fields
        end

        def form_fields
          _form_fields
        end

        def create_fields
          _create_fields.presence || _form_fields
        end

        def update_fields
          _update_fields.presence || _form_fields
        end

      end

    end
  end
end
