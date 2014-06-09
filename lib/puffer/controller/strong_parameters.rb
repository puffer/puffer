module Puffer
  module Controller
    module StrongParameters
      extend ActiveSupport::Concern

    private

      def resource_params
        params = super
        return params unless strong_params_action?

        result = params.permit(:id,
          configuration.model_name.to_s.underscore => fields(action_name).map(&:component).map(&:permitted_params)
        )

        # NOTE cannot permit puffer as scalar, so just add it into hash
        result.merge(:puffer => params[:puffer])
      end

      def strong_params_action?
        action_name.to_sym.in? [:create, :update]
      end
    end
  end
end
