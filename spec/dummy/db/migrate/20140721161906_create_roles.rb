class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :user_id
      t.string :role

      t.timestamps
    end

    add_index :roles, :user_id
  end
end
