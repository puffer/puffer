if defined?(ActiveRecord::Base)
  class PufferUser
    include Puffer::PufferUser
  end
end

if defined?(Mongoid::Document)
  class PufferUser
    include Mongoid::Document
    include Puffer::PufferUser

    field :email, :type => String
    field :password_digest, :type => String
    field :roles, :type => String
  end
end