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

  def new
    # @record = UserSession.new
  end

  def create
    # @record = UserSession.new params[:user_session]
    # respond_with record, :location => puffer_root_url
  end

  def destroy
    # @record = UserSession.find
    # @record.destroy
  end

end
