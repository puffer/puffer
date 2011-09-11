module Puffer
  module Extensions
    module ActiveRecord
      module Base

        def call_chain chain
          swallow_nil{instance_eval(chain.to_s)}
        end

      end
    end
  end
end

ActiveRecord::Base.send :include, Puffer::Extensions::ActiveRecord::Base
