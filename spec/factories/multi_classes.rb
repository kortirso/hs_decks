FactoryBot.define do
  factory :multi_class do
    sequence(:name) { |i| { en: "Grimy Goons #{i}", ru: "Ржавые Бугаи #{i}" } }
  end
end
