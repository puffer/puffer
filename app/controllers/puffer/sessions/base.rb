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
    # @record = resource.new_member
  end

  def create
    # @record = resource.new_member
    # if @record.save
    #   redirect_back_or admin_root_url
    # else
    #   render 'new'
    # end
  end

  def destroy
    # current_user_session.destroy
    # redirect_to new_admin_session_url
  end
end
