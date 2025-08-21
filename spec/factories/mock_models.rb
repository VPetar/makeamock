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
    associations do
      [
        { name: Faker::Lorem.word, type: "belongs_to", model: Faker::Lorem.word.capitalize },
        { name: Faker::Lorem.word.pluralize, type: "has_many", model: Faker::Lorem.word.capitalize }
      ]
    end

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
