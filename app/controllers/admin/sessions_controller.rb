# Implemented basic rails auth with custom PufferUser model.
# Admin::SessionsController could be redefined in application.
# See Puffer::SessionsBase docs for additional info.
class Admin::SessionsController < Puffer::SessionsBase

  def new
    @record = PufferUser.new
  end

  def create
    @record = PufferUser.find_by_email(params[:puffer_user][:email])
    if @record && @record.authenticate(params[:puffer_user][:password])
      session[:puffer_user_id] = @record.id
      redirect_to admin_root_url
    else
      @record = PufferUser.new :email => params[:puffer_user][:email]
      render 'new'
    end
  end

  def destroy
    session.delete(:puffer_user_id)
    redirect_to new_admin_session_url
  end

end
