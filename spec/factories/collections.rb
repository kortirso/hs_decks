FactoryBot.define do
  factory :collection do
    name(en: 'Basic', ru: 'Базовый набор')
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
