# == Schema Information
#
# Table name: invitations
#
#  id            :bigint           not null, primary key
#  email         :string           not null
#  expires_at    :datetime         not null
#  status        :string           default("pending"), not null
#  token         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  invited_by_id :bigint           not null
#  team_id       :bigint           not null
#
# Indexes
#
#  index_invitations_on_email_and_team_id  (email,team_id) UNIQUE
#  index_invitations_on_invited_by_id      (invited_by_id)
#  index_invitations_on_team_id            (team_id)
#  index_invitations_on_token              (token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (invited_by_id => users.id)
#  fk_rails_...  (team_id => teams.id)
#
class Invitation < ApplicationRecord
  belongs_to :team
  belongs_to :invited_by, class_name: "User"

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: %w[pending accepted declined pending_user_creation] }
  validates :expires_at, presence: true
  validates :email, uniqueness: { scope: :team_id, message: "has already been invited to this team" }

  before_validation :generate_token, on: :create
  before_validation :set_expiration, on: :create
  after_create :send_invitation_email

  scope :pending, -> { where(status: "pending") }
  scope :accepted, -> { where(status: "accepted") }
  scope :declined, -> { where(status: "declined") }
  scope :pending_user_creation, -> { where(status: "pending_user_creation") }
  scope :expired, -> { where("expires_at < ?", Time.current) }
  scope :valid, -> { where("expires_at > ?", Time.current) }

  def expired?
    expires_at < Time.current
  end

  def pending?
    status == "pending"
  end

  def accepted?
    status == "accepted"
  end

  def declined?
    status == "declined"
  end

  def pending_user_creation?
    status == "pending_user_creation"
  end

  def user_exists?
    User.exists?(email: email)
  end

  def accept!(user)
    return false if expired? || (!pending? && !pending_user_creation?)

    # Verify the user's email matches the invitation
    return false unless user.email == email

    ActiveRecord::Base.transaction do
      team.team_memberships.create!(user: user, role: "member")
      update!(status: "accepted")
    end

    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def decline!
    return false unless pending? || pending_user_creation?

    update(status: "declined")
  end

  def mark_pending_user_creation!
    return false unless pending?

    update(status: "pending_user_creation")
  end

  # Class method to create and send invitation
  def self.create_and_send!(email:, team:, invited_by:)
    invitation = create!(
      email: email,
      team: team,
      invited_by: invited_by
    )
    invitation
  end

  private

  def generate_token
    self.token ||= SecureRandom.uuid
  end

  def set_expiration
    self.expires_at ||= 7.days.from_now
  end

  def send_invitation_email
    InvitationMailerJob.perform_later(self)
  end
end
