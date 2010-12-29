class CreatePostCategories < ActiveRecord::Migration
  def self.up
    create_table :post_categories do |t|
      t.integer :post_id
      t.integer :category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :post_categories
  end
end
