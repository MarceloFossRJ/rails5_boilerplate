class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :confirmable, :async # :invitable, :lockable, :timeoutable, :validatable  and :omniauthable
  has_many :identities, dependent: :destroy
  has_many :members
  has_many :workspaces, through: :memberss
  has_many :invitations_sent, :class_name => 'Invitations', :foreign_key => 'sender_id'
  has_many :received_invitations, :class_name => 'Invitations', :foreign_key => 'recipient_id'
  has_one  :user_preference
  scope :by_workspace, -> (w) { joins(:members).where(workspace_id: w) }
  scope :by_workspace_subdomain, -> (w) { joins(:workspaces).where(subdomain: w) }
  scope :by_email, -> (u) {where(email: u)}
  
  attribute :from_oauth, :boolean
  attr_accessor :invitation_token

  validates :email, uniqueness: true
  validates :email, presence: true
  validates :name, presence: true
  validates :password, not_pwned: { threshold: 3,
                                    message: "has been detected in large security data breaches %{count} times. Please choose another.",
                                    if: :password_required?}
  validates :password, format: { with: /(?=.{6,}$)(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9]).*/,
                                 message: "should have at least 6 digits, with 1 number, 1 uppercase and 1 lowercase.",
                                 if: :password_required?}
  def default_workspace
    subdomain
  end

  def is_admin?(workspace)
    self.members.where(role: ['a','o'], workspace_id: workspace).exists?
  end

  def is_owner?(workspace)
    self.members.where(role: 'o', workspace_id: workspace).exists?
  end

  def is_member?(workspace)
    self.members.where(role: ['o','a','m'], workspace_id: workspace).exists?
  end

  # passwords must be required if users do not use oAuth to login
  def password_required?
    if self.from_oauth
      false
    else
      !Identity.has_oauth?(id)
    end
  end

  # update user data without informing the password
  def update_with_password(params, *options)
    if !password_required?
      begin
        update_attributes(params, *options)
      end
    else
      super
    end
  end

  # create user with full signup
  def create_with_transaction(params)
    ActiveRecord::Base.transaction do
      if params[:invitation_token].to_s.length > 0 # if user is invited associate user to invitation workspace and don't create a new one
        invitation = Invitation.find_by_token(params[:invitation_token])
        if invitation.email == self.email
          self.subdomain = invitation.workspace.subdomain
          self.skip_confirmation!
          self.save! # create user
          params[:workspace_id] = invitation.workspace_id
          params[:user_id] = id
          Member.create_ordinary_member(params)
          invitation.recipient_id = id
          invitation.accepted_at = Time.now
          invitation.save
        else
          errors.add(:email, "Email should be the same of the invitation")
          ActiveRecord::RecordInvalid.new(user)
        end
      else # user did not receive an invite, create individual workspace
        self.save! # create user
        params[:user_id] = id
        Workspace.create_single_user_workspace(params)
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    logger.debug "############### Error #{e.message}"
    if e.message.to_s.downcase.include? "subdomain"
      m = e.message
      errors.add(:subdomain, m)
    end
  end

  # oAuth methods
  def self.from_omni_auth(auth, subdomain)
    identity = Identity.find_by(provider: auth.provider, uid: auth.uid)
    if identity.nil?
      user = User.find_by(email: auth.email)
      if (subdomain.to_s.length > 0 && user.nil?) || # comes from signup or login, user don't exist
         (subdomain.to_s.length == 0 && user)        # comes from login, user exist but never logged in by oAuth
        invitation = Invitation.find_by_email(auth.email)
        if invitation.nil? && subdomain.to_s.length == 0 # user not registered did not receive an invitation
          raise 'Email not registered, please sign up first.'
        else
          case auth.provider
          when "github"
            create_with_github(auth, subdomain)
          when "linkedin"
            create_with_linkedin(auth, subdomain)
          when "google_oauth2"
            create_with_google(auth, subdomain)
          else
            raise "Authentication method not recognized"
          end
        end
      else
        raise "Email not registered, please sign up first!"
      end
    else
      return User.find(identity.user_id)
    end
  end

  private

  # oAuth private methods
  def self.create_with_github(auth, subdomain)
    params = Hash.new
    params[:subdomain] = subdomain
    params[:avatar] = auth["extra"]["raw_info"]["avatar_url"]
    #location = auth["extra"]["raw_info"]["location"]
    params[:email] = auth["info"]["email"]
    params[:name] = auth["info"]["name"]
    params[:provider] = "github"
    params[:uid] = auth["uid"]
    create_with_omniauth(params)
  end

  def self.create_with_linkedin(auth, subdomain)
    params = Hash.new
    params[:subdomain] = subdomain
    params[:avatar] = auth.info.picture_url
    params[:email] = auth.info.email
    params[:name] = "#{auth.info.first_name} #{auth.info.last_name}"
    params[:provider] = auth.provider
    params[:uid] = auth.uid
    create_with_omniauth(params)
  end

  def self.create_with_google(auth, subdomain)
    params = Hash.new
    params[:subdomain] = subdomain
    params[:avatar] = auth.info.image
    params[:email] = auth.info.email
    params[:name] = "#{auth.info.first_name} #{auth.info.last_name}"
    params[:provider] = auth.provider
    params[:uid] = auth.uid
    params[:token] = auth.credentials.token
    params[:token_expires_at] = auth.credentials.expires_at
    create_with_omniauth(params)
  end

  def self.create_with_omniauth(params)
    user = User.find_by(email: params[:email])
    if user.nil?
      user = User.new
      user.name = params[:name]
      user.email = params[:email]
      user.password = Devise.friendly_token[0,20]
      user.avatar = params[:avatar]
      user.subdomain = params[:subdomain]
      user.skip_confirmation!
      user.from_oauth = true
      user.create_with_transaction(params)
    else
      user.avatar = avatar if (user.avatar.nil? || user.avatar.blank?)
      user.name = name if user.name.nil?
      user.save!
    end
    Identity.create_for_oauth(params[:uid], params[:provider], user.id)
    return user
  end
end
