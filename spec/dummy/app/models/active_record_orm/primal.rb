class ActiveRecordOrm::Primal < ActiveRecord::Base
  has_one :has_one_nested, :validate => true, :class_name => 'ActiveRecordOrm::HasOneReference'
  has_many :has_many_nesteds, :validate => true, :class_name => 'ActiveRecordOrm::HasManyReference'

  accepts_nested_attributes_for :has_one_nested, :has_many_nesteds, :allow_destroy => true
end
