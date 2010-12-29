class CreateTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      t.string :name
      t.references :tag
      t.references :taggable, :polymorphic => true
    end

    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type]
  end

  def self.down
    drop_table :taggings
  end
end
