class Identity < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :uid, scope: [:provider]
  validates_presence_of :uid, :provider

  def self.has_oauth?(user_id)
    if user_id.to_s.length > 0
      where(user_id: user_id).exists?
    else
      false
    end
  end
  def self.create_for_oauth(uid, provider, user_id)
    find_or_create_by(uid: uid, provider: provider, user_id: user_id)
  end
end
