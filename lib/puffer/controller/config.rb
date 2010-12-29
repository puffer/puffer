module Puffer
  module Controller
    class Config

      attr_accessor :config
      cattr_accessor :default_config
      @@default_config = {}

      def initialize
        @config = {}
      end

      def self.option name, default
        @@default_config[name.to_sym] = default
        class_eval <<-EOS
          def #{name} value = nil
            value.nil? ? (@config.key?(:#{name}) ? @config[:#{name}] : self.class.default_config[:#{name}]) : @config[:#{name}] = value
          end
        EOS
      end

      option :destroy, true
      option :model, nil
      option :scope, {}

    end
  end
end
