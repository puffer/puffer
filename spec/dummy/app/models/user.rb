class User < ActiveRecord::Base
  has_one :profile
  has_many :posts

  has_many :friendships
  has_many :friendship_requests, :source => :friend, :through => :friendships, :conditions => {:state => 'requested'}
  has_many :friends, :through => :friendships, :conditions => {:state => 'accepted'}

  validates_presence_of :email, :password
  validates_length_of :password, :minimum => 6

  def to_title
    email
  end
end
