class ActiveRecordOrm::HasManyReference < ActiveRecord::Base
  belongs_to :primal

  validates :name, :presence => true
end
