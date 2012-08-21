class Post < ActiveRecord::Base
  has_many :post_categories
  has_many :categories, :through => :post_categories
  belongs_to :user

  validates :title, :presence => true

  def self.statuses
    %w(draft hidden published)
  end
end
