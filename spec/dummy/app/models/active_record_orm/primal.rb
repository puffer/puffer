class ActiveRecordOrm::Primal < ActiveRecord::Base
  has_one :has_one_reference, :validate => true
  has_many :has_many_references, :validate => true

  accepts_nested_attributes_for :has_one_reference, :has_many_references, :allow_destroy => true
end
