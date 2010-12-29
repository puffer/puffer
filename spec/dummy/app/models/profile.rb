class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :taggings, :as => :taggable
  has_many :tags, :through => :taggings
end
