module Puffer
  module Controller
    class Actions < Array

      %w(match get post put delete).each do |method|
        define_method method do |*args|
          push args.unshift(method)
        end
      end

    end
  end
end
