# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable

  has_many :team_memberships, dependent: :destroy
  has_many :teams, -> { select("teams.*, team_memberships.role, team_memberships.active") },
         through: :team_memberships
  has_many :sent_invitations, class_name: "Invitation", foreign_key: "invited_by_id", dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    [ "confirmation_sent_at", "confirmation_token", "confirmed_at", "created_at", "current_sign_in_at", "current_sign_in_ip", "email", "encrypted_password", "failed_attempts", "id", "id_value", "last_sign_in_at", "last_sign_in_ip", "locked_at", "remember_created_at", "reset_password_sent_at", "reset_password_token", "sign_in_count", "unconfirmed_email", "unlock_token", "updated_at" ]
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    email = conditions.delete(:email)
    where(conditions).where([ "lower(email) = :value", { value: email.downcase } ]).first.tap do |user|
      if user && !user.confirmed?
        user = nil
      end
    end
  end

  def has_team?
    teams.any?
  end

  def admin_of?(team)
    team_memberships.where(team: team, role: "admin").exists?
  end

  def member_of?(team)
    team_memberships.where(team: team).exists?
  end

  def admin_teams
    teams.joins(:team_memberships).where(team_memberships: { user: self, role: "admin" })
  end

  def member_teams
    teams.joins(:team_memberships).where(team_memberships: { user: self, role: "member" })
  end

  private

  def after_confirmation
    process_pending_invitations
  end

  def process_pending_invitations
    # Find all pending invitations for this user's email
    pending_invitations = Invitation.where(
      email: email,
      status: [ "pending", "pending_user_creation" ]
    ).valid

    pending_invitations.each do |invitation|
      invitation.accept!(self)
    end
  end
end
