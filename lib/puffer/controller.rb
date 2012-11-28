module Puffer
  module Controller
    extend ActiveSupport::Concern

    included do
      include Puffer::Controller::Fieldsets
    end
  end
end
