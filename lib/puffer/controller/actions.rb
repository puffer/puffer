module Puffer
  module Controller
    class Actions < Array

      %w(match get post put delete).each do |method|
        define_method method do |*args|
          push Action.new(args.unshift(method))
        end
      end

    end

    class Action < Array

      def initialize *args
        super *args
        options = extract_options!
        @display = options.key?(:display) ? options.delete(:display) : true
        push options
      end

      def method
        first
      end

      def action
        second
      end

      def display?
        @display
      end

    end

  end
end
