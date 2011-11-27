class MongoidOrm::EmbedsManyReference
  include Mongoid::Document

  field :name

  embedded_in :primal, :class_name => 'MongoidOrm::Primal'

  validates :name, :presence => true
end