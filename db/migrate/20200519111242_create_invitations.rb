class CreateInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations do |t|
      t.string :email
      t.references :workspace, foreign_key: true
      t.string     :token
      t.datetime   :sent_at
      t.datetime   :accepted_at
      t.integer    :invitation_limit
      t.integer    :sender_id
      t.integer    :recipient_id
      t.integer    :count, default: 0
      t.index      :count
      t.index      :token, unique: true # for invitable
      t.index      :sender_id
      t.index      :recipient_id

      t.timestamps
    end
  end
end
