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
