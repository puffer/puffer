class Puffer::PufferUser < ActiveRecord::Base
  self.abstract_class = true

  attr_protected :password_digest
  
  has_secure_password

  validates :email, :uniqueness => true, :presence => true
  validates :password, :presence => true, :length => {:minimum => 6}, :on => :create

  def roles= value
    value = value.split(',').map(&:strip).map(&:presence) if value.is_a?(String)
    write_attribute(:roles, value.join(', '))
  end

  def roles_array
    roles.split(',').map(&:strip).map(&:presence)
  end

  def has_role? role
    roles_array.include?(role.to_s)
  end

end
