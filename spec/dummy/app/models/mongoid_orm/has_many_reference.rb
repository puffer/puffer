class MongoidOrm::HasManyReference
  include Mongoid::Document

  field :name

  belongs_to :primal, :class_name => 'MongoidOrm::Primal'

  validates :name, :presence => true
end