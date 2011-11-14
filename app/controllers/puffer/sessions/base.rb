# Puffer::SessionsBase is a base class for any Admin::SessionsController
# implementation by default implemented basic auth through PufferUser.
# See Puffer::SessionsDeviseBase for alternative implementation example.
class Puffer::Sessions::Base < ApplicationController
  unloadable
  pufferize!

  before_filter :require_puffer_user, :only => :destroy

  define_fieldset :create, :fallbacks => :form

  layout 'puffer_sessions'

  respond_to :html

  setup do
    group nil
  end

  create do
    field :email, :type => :string
    field :password, :type => :password
  end

  def new
    # @record = UserSession.new
  end

  def create
    # @record = UserSession.new params[:user_session]
    # if @record.save
    #   redirect_back_or_default puffer_root_url
    # else
    #   render 'new'
    # end
  end

  def destroy
    # current_user_session.destroy
    # redirect_to new_puffer_session_url
  end

end
