module Puffer
  module Controller
    module Fieldsets
      class Fieldset < Array
        attr_accessor :name, :model

        def initialize name, model = nil
          @name, @model = name, model
          super()
        end

      end
    end
  end
end
