module Puffer
  module Extensions
    module ActiveRecord
      module Base

        def call_chain chain
          swallow_nil{instance_eval(chain.to_s)}
        end

        def to_title
          send title_method
        end

        def title_method
          self.class.column_names.detect {|c| c =~ /name|title/} || self.class.column_names[1].to_sym
        end

      end
    end
  end
end

ActiveRecord::Base.send :include, Puffer::Extensions::ActiveRecord::Base
