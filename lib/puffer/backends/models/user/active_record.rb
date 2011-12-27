require 'orm_adapter/adapters/active_record'

module Puffer
  module User
    class ActiveRecord < ActiveRecord::Base
      self.abstract_class = true

      include Puffer::User::Base
    end
  end
end
