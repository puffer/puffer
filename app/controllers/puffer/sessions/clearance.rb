# Puffer::Sessions::Clearance integrates Puffer admin interface
# builder with the Clearance authentication & authorization solution.
class Puffer::Sessions::Clearance < Puffer::Sessions::Base

  setup do
    model_name :user
  end

  def new
    @record = resource.new_member
  end

  def create
    # I used to follow the Clearance conventions
    params[:session] = params.delete resource.attributes_key
    
    if @record = authenticate(params) and sign_in(@record)
      redirect_back_or admin_root_url
    else
      @record = resource.new_member :email => params[:session][:email]
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to new_admin_session_url
  end
end
