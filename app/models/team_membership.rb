# == Schema Information
#
# Table name: team_memberships
#
#  id         :bigint           not null, primary key
#  role       :string           default("member"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_team_memberships_on_team_id              (team_id)
#  index_team_memberships_on_user_id              (user_id)
#  index_team_memberships_on_user_id_and_team_id  (user_id,team_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#  fk_rails_...  (user_id => users.id)
#
class TeamMembership < ApplicationRecord
  belongs_to :user
  belongs_to :team

  validates :role, presence: true, inclusion: { in: %w[admin member] }
  validates :user_id, uniqueness: { scope: :team_id, message: "is already a member of this team" }

  scope :admins, -> { where(role: "admin") }
  scope :members, -> { where(role: "member") }

  def admin?
    role == "admin"
  end

  def member?
    role == "member"
  end
end
