# == Schema Information
#
# Table name: mock_models
#
#  id           :bigint           not null, primary key
#  associations :jsonb            not null
#  fields       :jsonb            not null
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_mock_models_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :mock_model do
    association :user
    name { Faker::Lorem.word.capitalize + "Model" }
    fields do
      {
        Faker::Lorem.word => { type: "string", required: true },
        Faker::Lorem.word => { type: "integer", required: false },
        Faker::Lorem.word => { type: "boolean", required: true },
        Faker::Lorem.word => { type: "text", required: false },
        Faker::Lorem.word => { type: "datetime", required: true }
      }
    end
    associations { [] }

    trait :simple do
      fields do
        {
          "name" => { type: "string", required: true },
          "description" => { type: "text", required: false }
        }
      end
      associations { [] }
    end

    trait :complex do
      fields do
        {
          Faker::Lorem.word => { type: "string", required: true },
          Faker::Lorem.word => { type: "integer", required: false },
          Faker::Lorem.word => { type: "boolean", required: true },
          Faker::Lorem.word => { type: "text", required: false },
          Faker::Lorem.word => { type: "datetime", required: true },
          Faker::Lorem.word => { type: "decimal", required: false },
          Faker::Lorem.word => { type: "json", required: false }
        }
      end
      associations do
        [
          { name: Faker::Lorem.word, type: "belongs_to", model: Faker::Lorem.word.capitalize },
          { name: Faker::Lorem.word.pluralize, type: "has_many", model: Faker::Lorem.word.capitalize },
          { name: Faker::Lorem.word.pluralize, type: "has_and_belongs_to_many", model: Faker::Lorem.word.capitalize }
        ]
      end
    end

    trait :no_associations do
      associations { [] }
    end
  end
end
