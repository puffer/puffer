class Puffer::Sessions < ApplicationController
  unloadable

  pufferize!
  define_fields :create

  layout 'puffer_sessions'

  respond_to :html

  create do
    field :email, :type => :string
    field :password, :type => :password
  end

end
