class User < ApplicationRecord

  after_create :create_tenant
  after_destroy :delete_tenant
  before_validation :downcase_subdomain

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :validatable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable#, request_keys: [:subdomain]

  validates :email, uniqueness: true
  validates :subdomain, presence: true
  validates :subdomain, uniqueness: true
  validates :name, presence: true
  validates :country, presence: true
  validate :excluded_subdomains




  private
  def create_tenant
    Apartment::Tenant.create(subdomain)
    #load_seeds
  end

  def delete_tenant
    Apartment::Tenant.drop(subdomain)
  end

  def excluded_subdomains
    if ExcludedSubdomains.subdomains.include?(self.subdomain)
      errors.add(:subdomain, "Not permitted")
    end
  end

  def downcase_subdomain
    self.subdomain = subdomain.try(:downcase)
  end
end
