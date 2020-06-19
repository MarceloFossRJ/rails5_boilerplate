class Member < ApplicationRecord
  belongs_to :user
  belongs_to :workspace

  scope :by_workspace_subdomain, -> (u) { joins(:workspace).where( workspaces: {subdomain: u} ) }

  validates :user_id, presence: true
  validates :workspace_id, presence:true

  ROLE_NAME = {
      :o => "Owner",
      :a => "Admin",
      :m => "Member"
  }

  def role_name
    ROLE_NAME[self.role.to_sym]
  end

  def self.roles
    ROLE_NAME
  end

  def self.create_admin(params)
    member = Member.new
    member.user_id = params[:user_id]
    member.workspace_id = params[:workspace_id]
    member.role = 'a'
    member.save!
  end

  def self.create_owner(params)
    member = Member.new
    member.user_id = params[:user_id]
    member.workspace_id = params[:workspace_id]
    member.role = 'o'
    member.save!
  end

  def self.create_ordinary_member(params)
    member = Member.new
    member.user_id = params[:user_id]
    member.workspace_id = params[:workspace_id]
    member.role = 'm'
    member.save!
  end
end
