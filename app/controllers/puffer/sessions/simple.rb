class Puffer::Sessions::Simple < Puffer::Sessions::Base

  def new
    @record = resource.new_member
  end

  def create
    @record = resource.adapter.find_first(:conditions => {:email => params[:puffer_user][:email]})
    if @record && @record.authenticate(params[:puffer_user][:password])
      session[:puffer_user_id] = @record.id
      redirect_to admin_root_url
    else
      @record = resource.new_member :email => params[:puffer_user][:email]
      render 'new'
    end
  end

  def destroy
    session.delete(:puffer_user_id)
    redirect_to new_admin_session_url
  end

end
