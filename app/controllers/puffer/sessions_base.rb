class Puffer::SessionsBase < ApplicationController
  unloadable

  pufferize!
  view_paths_fallbacks :puffer_sessions
  define_fields :create

  layout 'puffer_sessions'

  respond_to :html

  create do
    field :email
    field :password
  end

end
