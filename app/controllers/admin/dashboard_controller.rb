class Admin::DashboardController < Puffer::DashboardBase
  unloadable

  def index
    render 'index'
  end

private

  def method_for_action name
    super action_method?(name.to_s) ? name : 'index'
  end
end
