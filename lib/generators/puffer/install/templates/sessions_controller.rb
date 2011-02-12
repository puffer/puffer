class Puffer::SessionsController < Puffer::SessionsBase
  # This is example session controller for puffer authentication.
  # You can define your own actions.
  # Also, you can redefine <tt>new<tt> action view as you wish,
  # but more effectively will be definig fields with standart
  # puffer DSL:
  #   create do
  #     field :login
  #     field :password
  #     field :remember_me
  #   end
  #
  # By default defined <tt>email<tt> and <tt>password<tt> fields.
  # If puffer can`t calculate field type, just set it manually.

  def new
    # @record = UserSession.new
  end

  def create
    # @record = UserSession.new params[:user_session]
    # if @record.save
    #   redirect_back_or_default puffer_root_url
    # else
    #   render 'new'
    # end
  end

  def destroy
    # current_user_session.destroy
    # redirect_to new_puffer_session_url
  end

end
