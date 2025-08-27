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
FactoryBot.define do
  factory :invitation do
    email { Faker::Internet.email }
    association :team
    association :invited_by, factory: :user
    status { "pending" }
    expires_at { 7.days.from_now }
    token { SecureRandom.urlsafe_base64(32) }

    trait :pending do
      status { "pending" }
    end

    trait :accepted do
      status { "accepted" }
    end

    trait :declined do
      status { "declined" }
    end

    trait :pending_user_creation do
      status { "pending_user_creation" }
    end

    trait :expired do
      expires_at { 1.day.ago }
    end
  end
end
