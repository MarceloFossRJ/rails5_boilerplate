class CreateWorkspaces < ActiveRecord::Migration[5.2]
  def change
    create_table :workspaces do |t|
      t.string :name
      t.string :logo
      t.string :subdomain
      t.boolean :is_multiuser
      t.boolean :user_can_self_exclude
      t.boolean :user_can_invite
      #t.belongs_to :owner, null: false, foreign_key: {to_table: :users}

      t.timestamps
    end

    add_index :workspaces, :subdomain, unique: true
  end
end
