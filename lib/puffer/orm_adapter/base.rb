module Puffer
  module OrmAdapter
    module Base

      def columns_hash
        raise ::OrmAdapter::NotSupportedError
      end

      def reflection name
        raise ::OrmAdapter::NotSupportedError
      end

      def filter scope, fields, options = {}
        raise ::OrmAdapter::NotSupportedError
      end

      def merge_scopes scope, additional
        raise ::OrmAdapter::NotSupportedError
      end

    end

    class Reflection < ActiveSupport::OrderedOptions

      def initialize hash
        super
        hash.each { |(key, value)| self[key] = value }
      end

    end
  end
end

OrmAdapter::Base.send :include, Puffer::OrmAdapter::Base