class Admin::DashboardController < ApplicationController
  unloadable

  layout 'puffer'
  helper :puffer

  include Puffer::Controller::Helpers

  def index
    @title = 'Dashboard'
  end

end
