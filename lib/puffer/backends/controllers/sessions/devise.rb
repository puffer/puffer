class Puffer::Sessions::Devise < Puffer::Sessions::Base

  before_filter :allow_params_authentication!, :only => :create

  setup do
    model_name :user
  end

  def new
    @record = resource.new_member
  end

  def create
    @record = warden.authenticate(:scope => model_name.to_sym)
    if @record && sign_in(@record)
      redirect_back_or admin_root_url
    else
      @record = resource.new_member :email => resource.attributes[:email]
      render 'new'
    end
  end

  def destroy
    sign_out model_name.to_sym
    redirect_to puffer.new_admin_session_url
  end

end