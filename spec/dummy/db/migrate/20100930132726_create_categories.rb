class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :title
      t.boolean :hidden

      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
