class ApplicationController < ActionController::Base
  include Clearance::Authentication
  protect_from_forgery

  def current_puffer_user
    nil
  end

  def has_puffer_access? namespace
    true
  end
end
