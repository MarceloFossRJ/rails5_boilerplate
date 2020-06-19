class AddDefaultCurrenciesToWorkspace < ActiveRecord::Migration[5.2]
  def change
    add_column :workspaces, :default_currencies, :string
    add_column :journeys, :default_currencies, :string
  end
end
