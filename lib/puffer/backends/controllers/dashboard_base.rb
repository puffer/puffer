class Puffer::DashboardBase < ApplicationController
  pufferize!

  before_filter :require_puffer_user

  layout 'puffer_dashboard'

  respond_to :html

  setup do
    group nil
  end

  def index
    
  end

end
