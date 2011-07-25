class Puffer::DashboardBase < ApplicationController
  unloadable

  pufferize!

  layout 'puffer_dashboard'

  def index

  end

end
