class ActiveRecordOrm::HasOneReference < ActiveRecord::Base
  belongs_to :primal

  validates :name, :presence => true
end
