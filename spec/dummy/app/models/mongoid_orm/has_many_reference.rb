class MongoidOrm::HasManyReference
  include Mongoid::Document

  field :name

  belongs_to :primal_nested, :inverse_of => :has_many_nesteds, :class_name => 'MongoidOrm::Primal'
  belongs_to :primal_reference, :inverse_of => :has_many_references, :class_name => 'MongoidOrm::Primal'

  validates :name, :presence => true
end