class Puffer::PufferUser < ActiveRecord::Base
  self.abstract_class = true

  attr_protected :password_digest
  
  has_secure_password

  validates :email, :uniqueness => true
  validates :password, :presence => true, :on => :create
  validates :password, :confirmation => true

  def roles= value
    value = value.split(',').map(&:strip).map(&:presence) if value.is_a?(String)
    write_attribute(:roles, value.join(', '))
  end

  def roles_array
    roles.split(',').map(&:strip).map(&:presence)
  end

  def has_role? role
    roles.roles_array.include?(role.to_s)
  end

end
