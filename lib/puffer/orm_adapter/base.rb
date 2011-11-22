module Puffer
  module OrmAdapter
    module Base

      def columns_hash
        raise NotSupportedError
      end

      def filter scope, fields, options = {}
        raise NotSupportedError
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