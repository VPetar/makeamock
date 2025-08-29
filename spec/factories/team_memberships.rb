# == Schema Information
#
# Table name: team_memberships
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(TRUE), not null
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
FactoryBot.define do
  factory :team_membership do
    association :user
    association :team
    role { "member" }

    trait :admin do
      role { "admin" }
    end

    trait :member do
      role { "member" }
    end
  end
end
