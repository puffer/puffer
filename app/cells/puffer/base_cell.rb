module Puffer
  class BaseCell < ::Cell::Rails

    build do
      self.class.to_s.gsub(/Controller$/, 'Cell').constantize rescue Puffer::BaseCell
    end

    helper_method :resource, :resource_session

    def additional
      render
    end

  private

    def resource
      parent_controller.resource
    end

    def resource_session
      parent_controller.resource_session
    end

  end
end
