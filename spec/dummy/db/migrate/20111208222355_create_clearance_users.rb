class CreateClearanceUsers < ActiveRecord::Migration
  def change
    create_table :clearance_users do |t|
      t.string :email
      t.string :encrypted_password, :limit => 128
      t.string :salt, :limit => 128
      t.string :confirmation_token, :limit => 128
      t.string :remember_token, :limit => 128

      t.timestamps
    end
  end
end
