FactoryBot.define do
  factory :team do
    name { Faker::Company.name }

    trait :with_users do
      after(:create) do |team|
        3.times do
          user = create(:user)
          team.users << user
        end
      end
    end

    trait :with_admin do
      after(:create) do |team|
        admin_user = create(:user)
        create(:team_membership, team: team, user: admin_user, role: "admin")
      end
    end

    trait :with_members do
      after(:create) do |team|
        2.times do
          member_user = create(:user)
          create(:team_membership, team: team, user: member_user, role: "member")
        end
      end
    end

    trait :with_invitations do
      after(:create) do |team|
        2.times do
          create(:invitation, team: team)
        end
      end
    end
  end
end
