class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.references :user, foreign_key: true
      t.references :workspace, foreign_key: true
      t.boolean :is_admin
      t.boolean :is_owner

      t.timestamps
    end

    add_index :members, [:user_id, :workspace_id],    unique: true
  end
end

