module Puffer
  module Controller
    class Actions < Array
      attr_accessor :controller
      attr_accessor :scope

      def initialize scope
        @scope = scope.to_s
        super()
      end

      %w(match get post put delete).each do |method|
        define_method method do |*route|
          push action_class.new(controller, *route.unshift(method))
        end
      end

      def action_class
        "Puffer::Controller::#{scope.camelize}Action".constantize
      end

    end

    class Action
      attr_accessor :controller, :route

      def initialize controller, *route
        @controller, @route = controller, route
        options = route.extract_options!
        @display = options.key?(:display) ? options.delete(:display) : true
        route.push options
      end

      def method
        @method ||= route.first.to_sym
      end

      def action
        @action ||= route.second.to_sym
      end

      def label
        I18n.t(action, :scope => i18n_scope, :default => action.to_s.humanize)
      end

      def i18n_scope
        [:puffer, controller.controller_path.gsub(/\//, '.'), action_scope]
      end

      def action_scope
        :actions
      end

      def display?
        @display
      end

    end

    class MemberAction < Action

      def action_scope
        :members
      end

    end

    class CollectionAction < Action

      def action_scope
        :collections
      end

    end

  end
end
