# Puffer::Sessions::Clearance integrates Puffer admin interface
# builder with the Clearance authentication & authorization solution.
class Puffer::Sessions::Clearance < Puffer::Sessions::Base
  def new
    @record = User.new
  end

  def create
    # I used to follow the Clearance conventions
    params[:session] = params.delete :user
    if @record = authenticate(params) and sign_in(@record)
      redirect_to admin_root_url
    else
      @record = User.new(params[:session])
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to new_admin_session_url
  end
end
