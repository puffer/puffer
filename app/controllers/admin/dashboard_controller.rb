class Admin::DashboardController < ApplicationController
  unloadable

  include Puffer::Controller::Mutate
  include Puffer::Controller::Helpers
  include Puffer::Controller::Config

  def index
    p Rails.application.routes.puffer
    @title = 'Dashboard'
  end

end
