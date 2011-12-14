class Puffer::Sessions::Simple < Puffer::Sessions::Base

  setup do
    model_name :puffer_user
  end

  def new
    @record = resource.new_member
  end

  def create
    @record = resource.adapter.find_first(:conditions => {:email => resource.attributes[:email]})
    
    if @record && @record.authenticate(resource.attributes[:password])
      session[:puffer_user_id] = @record.id
      redirect_back_or admin_root_url
    else
      @record = resource.new_member :email => resource.attributes[:email]
      render 'new'
    end
  end

  def destroy
    session.delete(:puffer_user_id)
    redirect_to new_admin_session_url
  end

end
