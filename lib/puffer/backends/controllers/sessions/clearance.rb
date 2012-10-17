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
    if @record = authenticate and sign_in(@record)
      redirect_back_or admin_root_url
    else
      @record = resource.new_member :email => resource.attributes[:email]
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to puffer.new_admin_session_url
  end

private

  def authenticate
    model.authenticate(resource.attributes[:email], resource.attributes[:password])
  end

end
