class Puffer::Sessions::Devise < Puffer::Sessions::Base
  # include Devise::Controllers::InternalHelpers

  # GET /resource/sign_in
  # def new
  #   @record = User.new
  # end

  # POST /resource/sign_in
  # def create
  #   @record = warden.authenticate!(:scope => :user, :recall => "#{controller_path}#new")
  #   sign_in(user, @record)
  #   respond_with @record, :location => params[:return_to]
  # end

  # GET /resource/sign_out
  # def destroy
  #   signed_in = signed_in?(resource_name)
  #   Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
  #   set_flash_message :notice, :signed_out if signed_in

  #   # We actually need to hardcode this, as Rails default responder doesn't
  #   # support returning empty response on GET request
  #   respond_to do |format|
  #     format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name) }
  #     format.all do
  #       method = "to_#{request_format}"
  #       text = {}.respond_to?(method) ? {}.send(method) : ""
  #       render :text => text, :status => :ok
  #     end
  #   end
  # end

end