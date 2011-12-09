class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_puffer_user
    nil
  end

  def has_puffer_access? namespace
    true
  end
end
