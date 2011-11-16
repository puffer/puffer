if defined?(Mongoid::Document)
  class PufferUser
    include Mongoid::Document

    field :email, :type => String
    field :password_digest, :type => String
    field :roles, :type => String

    include Puffer::PufferUser
  end
elsif defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.table_exists?('puffer_users')
  class PufferUser < ActiveRecord::Base
    include Puffer::PufferUser
  end
else
  class PufferUser
  end
end