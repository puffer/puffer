module Puffer
  module Component
    module ExampleGroup
      extend ActiveSupport::Concern
      include RSpec::Rails::RailsExampleGroup
      include Puffer::Component::TestCase::Behavior

      included do
        subject{component}
        metadata[:type] = :component
      end

      module ClassMethods
        def component_class
          described_class
        end
      end
    end
  end
end
