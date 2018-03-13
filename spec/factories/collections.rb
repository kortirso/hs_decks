FactoryBot.define do
  factory :collection do
    sequence(:name) { |i| { en: "Basic #{i}", ru: "Базовый набор _#{i}" } }
    formats 'standard'
    adventure false

    trait :wild_collection do
      formats 'wild'
    end

    trait :adventure do
      adventure true
    end
  end
end
