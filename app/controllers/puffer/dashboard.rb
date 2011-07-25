class Puffer::Dashboard < ApplicationController
  unloadable

  pufferize!

  layout 'puffer_dashboard'

  def index

  end

end
