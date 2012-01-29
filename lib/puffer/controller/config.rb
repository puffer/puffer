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
        puffer_class_attribute :group, :default
        #  model_name - obviosly - model name for controller
        puffer_class_attribute :model_name
        #  destroy - records destruction allowed?
        puffer_class_attribute :destroy, true
        #  destroy - records show method allowed?
        puffer_class_attribute :show, false
        #  scope - default scope name for all queries
        puffer_class_attribute :scope
        #  order - default order option. Is a string with field name and direction. Ex: 'email', 'first_name asc', 'title desc'
        puffer_class_attribute :order
        # obviously< records per page
        puffer_class_attribute :per_page, 30

        helper_method :configuration
      end

      def configuration
        self.class.configuration
      end

      module ClassMethods

        def puffer_class_attribute name, default = nil
          class_attribute "_puffer_attribute_#{name}"
          send "_puffer_attribute_#{name}=", default
        end

        def setup &block
          block.bind(Config.new(self)).call
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
          method_name = "_puffer_attribute_#{method}"
          if args.present? && controller.respond_to?("#{method_name}=")
            controller.send "#{method_name}=", args.first
          elsif controller.respond_to?(method_name)
            controller.send method_name
          else
            super
          end
        end

      end

    end
  end
end
