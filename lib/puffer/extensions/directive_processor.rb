require 'sprockets'

module Puffer
  module Extensions
    module DirectiveProcessor
      extend ActiveSupport::Concern

      included do

      end

      module InstanceMethods

        def process_require_all_directive(path)
          raise ArgumentError, "require_all argument must be relative" unless relative?(path)

          context.environment.paths.each do |root_path|
            root = Pathname.new(root_path).join(path).expand_path

            if root.exist? && root.directory?
              context.depend_on(root)

              Dir["#{root}/*"].sort.each do |filename|
                if filename == self.file
                  next
                elsif context.asset_requirable?(filename)
                  context.require_asset(filename)
                end
              end
            end
          end
        end

      end

    end
  end
end

Sprockets::DirectiveProcessor.send :include, Puffer::Extensions::DirectiveProcessor