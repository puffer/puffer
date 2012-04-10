class MongoidOrm::HasOneReference
  include Mongoid::Document

  field :name

  belongs_to :primal_nested, :inverse_of => :has_one_nested, :class_name => 'MongoidOrm::Primal'
  belongs_to :primal_reference, :inverse_of => :has_one_reference, :class_name => 'MongoidOrm::Primal'

  validates :name, :presence => true
end