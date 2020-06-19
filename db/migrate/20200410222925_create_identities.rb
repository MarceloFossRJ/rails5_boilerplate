class CreateIdentities < ActiveRecord::Migration[5.2]
  def change
    create_table :identities do |t|
      t.references :user, foreign_key: true
      t.string :uid
      t.string :provider
      t.string :oauth_token
      t.datetime :oauth_expires_at

      t.timestamps
    end
    add_index :identities, [:provider, :uid],    unique: true
    add_index :identities, :provider
    add_index :identities, :uid
  end
end
