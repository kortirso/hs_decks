FactoryBot.define do
  factory :player do
    name(en: 'Shaman', ru: 'Шаман')

    trait :with_multiclass do
      association :multi_class
    end
  end
end
