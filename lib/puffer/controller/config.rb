# Every puffer controller can be configured
# Something like:
#
#   setup do
#     group :posting
#     model_name 'article'
#   end
#
module Puffer
  module Controller
    module Config
      extend ActiveSupport::Concern

      included do
        # Configuration options with default values:
        #  group - interface group name, displays as tab in interface header
        puffer_config_option :group, :default
        #  model_name - obviosly - model name for controller
        puffer_config_option :model_name
        #  destroy - records destruction allowed?
        puffer_config_option :destroy, true
        #  destroy - records show method allowed?
        puffer_config_option :show, false
        #  scope - default scope for all queries
        puffer_config_option :scope
        #  order - default order option. Is a string with field name and direction. Ex: 'email', 'first_name asc', 'title desc'
        puffer_config_option :order
        # obviously< records per page
        puffer_config_option :per_page, 30
      end

      def configuration
        self.class.configuration
      end

      module ClassMethods

        def puffer_config_option name, default = nil
          class_attribute "_puffer_config_option_#{name}"
          send "_puffer_config_option_#{name}=", default
        end

        def setup &block
          block.bind(configuration).call
        end

        def configuration
          @configuration ||= Config.new(self)
        end

      end

      class Config

        attr_accessor :controller

        def initialize controller
          @controller = controller
        end

        def method_missing method, *args, &block
          method_name = "_puffer_config_option_#{method}"
          if (args.present? || block) && controller.respond_to?("#{method_name}=")
            controller.send "#{method_name}=", args.first.presence || block
          elsif controller.respond_to?(method_name)
            value = controller.send(method_name)
            value = value.call if value.respond_to?(:call)
            value
          else
            super
          end
        end

      end

    end
  end
end
