# Implemented basic rails auth with custom PufferUser model.
# Admin::SessionsController could be redefined in application.
# See Puffer::SessionsBase docs for additional info.
class Admin::SessionsController < Puffer::Sessions::Simple
  unloadable
end
