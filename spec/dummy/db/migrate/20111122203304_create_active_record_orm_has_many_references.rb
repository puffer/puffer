class CreateActiveRecordOrmHasManyReferences < ActiveRecord::Migration
  def change
    create_table :active_record_orm_has_many_references do |t|
      t.string :name
      t.integer :primal_id

      t.timestamps
    end
  end
end
