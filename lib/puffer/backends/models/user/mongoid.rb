require 'orm_adapter/adapters/mongoid'

module Puffer
  module User
    class Mongoid
      include ::Mongoid::Document

      self.collection_name = 'puffer_users' 

      field :email, :type => String
      field :password_digest, :type => String
      field :roles, :type => String

      include Puffer::User::Base
    end
  end
end
