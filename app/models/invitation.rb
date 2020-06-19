class Invitation < ApplicationRecord
  belongs_to :workspace
  belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_id'
  belongs_to :recipient, :class_name => 'User', :foreign_key => 'recipient_id', optional: true

  validates :workspace_id, presence: true
  validates :sender_id, presence: true
  validates :email, presence: true
  validates :workspace_id, uniqueness: { scope: :email }
  validates :count, numericality: { less_than_or_equal_to: Variables::InvitationPreferences::Limit || 5}
  validates :email, format: { with: /\A[^@]+@[^@]+\z/,
                              message: "Invalid email format" }

  before_create :generate_token

  scope :by_subdomain, -> (u) { joins(:workspace).where( workspace: { subdomain: u }) }
  scope :by_workspace, -> (u) { where( workspace_id: u )}
  scope :pending, -> { where(accepted_at: nil) }

  def generate_token
    self.token = Digest::SHA1.hexdigest([self.workspace_id, Time.now, rand].join)
  end

  def validate_single_user
    if !self.workspace.is_multiuser
      errors.add(:email, "Workspace is single user")
    end
  end

  def create_with_transaction(params)
    ActiveRecord::Base.transaction do
      # check if user exists
      if User.find_by_email(params[:email])
        self.recipient_id = user.id
        self.accepted_at = Time.now
        self.save!
        member = Member.new
        member.workspace_id = workspace_id
        member.user_id = user.id
        member.role = 'm'
        member.save!
      else
        self.save!
      end
    end
  rescue ActiveRecord::RecordInvalid => e
      m = e.message
      errors.add(:email, m)
  end

end
