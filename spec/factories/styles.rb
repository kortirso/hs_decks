FactoryBot.define do
  factory :style do
    sequence(:name) { |i| { en: "Aggro_#{i}", ru: "Агро_#{i}" } }
  end
end
