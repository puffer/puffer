class CreateActiveRecordOrmPrimals < ActiveRecord::Migration
  def change
    create_table :active_record_orm_primals do |t|
      t.string :string_field
      t.text :text_field
      t.string :select_field
      t.integer :integer_field
      t.float :float_field
      t.decimal :decimal_field
      t.datetime :datetime_field
      t.timestamp :timestamp_field
      t.time :time_field
      t.date :date_field
      t.boolean :boolean_field
    end
  end
end
