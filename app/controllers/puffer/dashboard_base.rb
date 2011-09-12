class Puffer::DashboardBase < ApplicationController
  unloadable
  pufferize!

  before_filter :require_puffer_user

  layout 'puffer_dashboard'

  def index

  end

end
