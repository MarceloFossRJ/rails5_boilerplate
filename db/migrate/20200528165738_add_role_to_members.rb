class AddRoleToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :role, :string, :default => 'u'
    remove_column :members, :is_admin
    remove_column :members, :is_owner
  end
end
