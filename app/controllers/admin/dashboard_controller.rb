class Admin::DashboardController < ApplicationController
  unloadable

  layout 'puffer'

  include Puffer::Controller::Helpers

  def index
    p Rails.application.routes.puffer
    @title = 'Dashboard'
  end

end
