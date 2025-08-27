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
FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password(min_length: 8, max_length: 128) }
    password_confirmation { password }

    # Devise trackable fields
    sign_in_count { rand(0..100) }
    current_sign_in_at { Faker::Time.between(from: 1.week.ago, to: Time.current) }
    last_sign_in_at { Faker::Time.between(from: 1.month.ago, to: current_sign_in_at) }
    current_sign_in_ip { Faker::Internet.ip_v4_address }
    last_sign_in_ip { Faker::Internet.ip_v4_address }

    # Devise confirmable fields
    confirmed_at { Faker::Time.between(from: 1.month.ago, to: Time.current) }
    confirmation_sent_at { confirmed_at - rand(1..24) * 3600 } # Using seconds instead of .hour

    # Devise rememberable field
    remember_created_at { rand > 0.5 ? Faker::Time.between(from: 1.week.ago, to: Time.current) : nil }

    # Devise lockable fields (most users won't be locked)
    failed_attempts { rand(0..2) }
    locked_at { nil }

    trait :unconfirmed do
      confirmed_at { nil }
      confirmation_sent_at { Faker::Time.between(from: 1.day.ago, to: Time.current) }
    end

    trait :locked do
      failed_attempts { rand(3..10) }
      locked_at { Faker::Time.between(from: 1.day.ago, to: Time.current) }
    end

    trait :with_reset_password do
      reset_password_sent_at { Faker::Time.between(from: 1.hour.ago, to: Time.current) }
    end

    trait :never_signed_in do
      sign_in_count { 0 }
      current_sign_in_at { nil }
      last_sign_in_at { nil }
      current_sign_in_ip { nil }
      last_sign_in_ip { nil }
    end

    trait :with_team do
      after(:create) do |user|
        team = create(:team)
        create(:team_membership, team: team, user: user, role: "admin")
      end
    end
  end
end
