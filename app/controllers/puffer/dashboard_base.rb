class Puffer::DashboardBase < ApplicationController
  unloadable

  pufferize!
  view_paths_fallbacks :puffer_dashboard

  layout 'puffer_dashboard'

  def index

  end

end
