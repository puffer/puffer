module Puffer
  module Extensions
    module ActiveRecord
      module Base

        def call_chain chain
          swallow_nil{instance_eval(chain.to_s)}
        end

        def to_title
          send title_column
        end

        def title_column
          self.class.column_names[1].to_sym
        end

      end
    end
  end
end

ActiveRecord::Base.send :include, Puffer::Extensions::ActiveRecord::Base
