# Implemented basic rails auth with custom PufferUser model.
# Admin::SessionsController could be redefined in application.
# See Puffer::SessionsBase docs for additional info.
class Admin::SessionsController < Puffer::Sessions::Simple

  setup do
    model_name :puffer_user
  end

end
