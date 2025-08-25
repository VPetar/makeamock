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
