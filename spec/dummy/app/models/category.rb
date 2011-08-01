class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, :through => :post_categories

  acts_as_nested_set
end
