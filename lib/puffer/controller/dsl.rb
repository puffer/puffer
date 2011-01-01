module Puffer
  module Controller
    module Dsl

      def self.included base
        base.class_eval do
          class_attribute :puffer_fields
          self.puffer_fields = {}

          extend ClassMethods

          helper_method :index_fields, :show_fields, :form_fields, :create_fields, :update_fields
        end
      end

      [:index, :show, :form, :create, :update].each do |sym|
        define_method "#{sym}_fields" do
          self.class.send "#{sym}_fields"
        end
      end

      module ClassMethods

        def configure &block
          block.bind(current_config).call
        end

        [:index, :show, :form, :create, :update].each do |sym|
          define_method sym do
            @puffer_option = sym
            yield if block_given?
          end
        end

        def index_fields
          puffer_fields[:index] || Puffer::Fields.new
        end

        def show_fields
          puffer_fields[:show] || puffer_fields[:index] || Puffer::Fields.new
        end

        def form_fields
          puffer_fields[:form] || Puffer::Fields.new
        end

        def create_fields
          puffer_fields[:create] || puffer_fields[:form] || Puffer::Fields.new
        end

        def update_fields
          puffer_fields[:update] || puffer_fields[:form] || Puffer::Fields.new
        end

        def field name, options = {}
          puffer_fields[@puffer_option] ||= Puffer::Fields.new
          field = puffer_fields[@puffer_option].field(current_resource.model, name, options)
          #generate_association_actions field if field.association?
          #generate_change_actions field if field.toggable?
        end

      end

    end
  end
end
