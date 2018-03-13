FactoryBot.define do
  factory :player do
    sequence(:name) { |i| { en: "Shaman_#{i}", ru: "Шаман_#{i}" } }

    trait :with_multiclass do
      association :multi_class
    end
  end
end
