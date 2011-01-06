module Puffer
  module Extensions
    module Mapper

      def self.included base
        base.class_eval do
          alias_method :original_resource, :resource
          alias_method :original_resources, :resources

          include InstanceMethods
        end
      end

      module InstanceMethods

        def resource *resources, &block
          puffer_resource(*resources, &block) || original_resource(*resources, &block)
        end

        def resources *resources, &block
          puffer_resources(*resources, &block) || original_resources(*resources, &block)
        end

        def puffer_controller controller
          puffer = Rails.application.routes.puffer
          prefix = @scope[:module]
          puffer[prefix] ||= ActiveSupport::OrderedHash.new
          puffer[prefix][controller.configuration.group] ||= []
          puffer[prefix][controller.configuration.group] << controller
        end

        def puffer_resource(*resources, &block)
          options = resources.extract_options!

          if apply_common_behavior_for(:resource, resources, options, &block)
            return self
          end

          resource = ActionDispatch::Routing::Mapper::Resources::SingletonResource.new(resources.pop, options)
          controller = "#{[@scope[:module], resource.controller].compact.join("/")}_controller".classify.constantize rescue nil

          return if controller.nil? || (controller && !controller.puffer?)

          @scope[:ancestors] ||= []
          @scope[:children] ||= []

          puffer_controller controller if @scope[:ancestors] == []

          resource_scope(resource) do
            siblings = @scope[:children].dup
            @scope[:children] = []
            @scope[:ancestors].push resource.singular.to_sym

            yield if block_given?

            @scope[:ancestors].pop
            options = {:plural => false, :ancestors => @scope[:ancestors].dup, :children => @scope[:children].dup}
            siblings.push resource.singular.to_sym
            @scope[:children] = siblings

            collection do
              post :create, options
            end

            new do
              get :new, options
            end

            member do
              get    :edit, options
              get    :show, options
              put    :update, options
              delete :destroy, options
            end

          end

          self
        end

        def puffer_resources(*resources, &block)
          options = resources.extract_options!

          if apply_common_behavior_for(:resources, resources, options, &block)
            return self
          end

          resource = ActionDispatch::Routing::Mapper::Resources::Resource.new(resources.pop, options)
          controller = "#{[@scope[:module], resource.controller].compact.join("/")}_controller".classify.constantize rescue nil

          return if controller.nil? || (controller && !controller.puffer?)

          @scope[:ancestors] ||= []
          @scope[:children] ||= []

          puffer_controller controller if @scope[:ancestors] == []

          resource_scope(resource) do
            siblings = @scope[:children].dup
            @scope[:children] = []
            @scope[:ancestors].push resource.plural.to_sym

            yield if block_given?

            @scope[:ancestors].pop
            options = {:plural => true, :ancestors => @scope[:ancestors].dup, :children => @scope[:children].dup}
            siblings.push resource.plural.to_sym
            @scope[:children] = siblings


            collection do
              get  :index, options
              post :create, options
            end

            new do
              get :new, options
            end

            member do
              get    :edit, options
              get    :show, options
              put    :update, options
              delete :destroy, options
            end
          end

          self
        end

      end

    end

    module RouteSet

      def self.included base
        base.class_eval do
          alias_method :original_clear!, :clear!
          attr_accessor_with_default :puffer, {}

          include InstanceMethods
        end
      end

      module InstanceMethods

        def clear!
          self.puffer = {}
          original_clear!
        end

      end

    end

  end
end

ActionDispatch::Routing::RouteSet.send :include, Puffer::Extensions::RouteSet
ActionDispatch::Routing::Mapper.send :include, Puffer::Extensions::Mapper
