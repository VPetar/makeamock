# == Schema Information
#
# Table name: teams
#
#  id         :bigint           not null, primary key
#  guid       :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_teams_on_guid  (guid) UNIQUE
#
class Team < ApplicationRecord
  has_many :team_memberships, dependent: :destroy
  has_many :users, through: :team_memberships
  has_many :invitations, dependent: :destroy
  has_many :mock_models, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :guid, presence: true, uniqueness: true

  before_validation :generate_guid, on: :create

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "guid", "id", "id_value", "name", "updated_at" ]
  end

  def admins
    users.joins(:team_memberships).where(team_memberships: { team: self, role: "admin" })
  end

  def members
    users.joins(:team_memberships).where(team_memberships: { team: self, role: "member" })
  end

  private

  def generate_guid
    self.guid ||= SecureRandom.uuid
  end
end
