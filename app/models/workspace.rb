class Workspace < ApplicationRecord
  has_many :members
  has_many :users, through: :members
  has_many :invitations
  scope :by_member, -> (u) { joins(:members).where(members: { user_id: u }) }
  scope :by_subdomain, -> (u) { where( subdomain: u ).first }
  scope :by_name, -> (u) { where( name: u ) }
  after_create :create_tenant
  after_destroy :drop_tenant
  before_save :add_logo
  validates :subdomain, presence: true
  validates :name, presence: true
  validates :subdomain, uniqueness: true
  validates :subdomain, uniqueness: { case_sensitive: false }
  validates :subdomain, format: { with: /\A[A-Za-z0-9_-]+\z/,
                                  message: "only allows numbers, letters - and _" }
  validate :excluded_subdomains
  mount_uploader :logo, LogoUploader

  def self.validate_subdomain(value)
    w = Workspace.new(:subdomain => value)
    w.valid?
    e = w.errors[:subdomain]
    return e.empty?, e
  end

  def add_logo
    if self.logo.to_s.length == 0
      self.logo = Pathname.new(Rails.root.join("public/logos/#{rand(14)}.png")).open
      self.save!
    end
  end

  def create_with_transaction(params)
    ActiveRecord::Base.transaction do
      # create workspace
      self.save!
      # create the member as workspace owner
      params[:workspace_id] = id
      Member.create_owner(params)
    end
  rescue ActiveRecord::RecordInvalid => e
    m = e.message
    errors.add(:subdomain, m)
  end

  def self.create_single_user_workspace(params)
    workspace = Workspace.new
    workspace.subdomain = params[:subdomain]
    workspace.is_multiuser = false
    workspace.name = params[:subdomain]
    workspace.save!
    params[:workspace_id] = workspace.id
    Member.create_owner(params)
  end

  private
  def load_seeds
    #Rails.application.load tasks unless ::Rake::Task.task_defined?('db:seed')
    Apartment::Tenant.switch(subdomain) do
      #::Rake::Task["db:seed"].invoke
      Rails.application.load_seed
    end
  end

  def excluded_subdomains
    if ExcludedSubdomains.subdomains.include?(self.subdomain)
      errors.add(:subdomain, "Not permitted")
    end
  end

  def create_tenant
    Apartment::Tenant.create(subdomain)
    load_seeds
  end

  def drop_tenant
    Apartment::Tenant.drop(subdomain)
  end

end
