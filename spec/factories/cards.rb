FactoryBot.define do
  factory :card do
    sequence(:cardId) { |i| "cardId_#{i}" }
    sequence(:name) { |i| { en: "name_en_#{i}", ru: "name_ru_#{i}" } }
    type 'Spell'
    cost 0
    playerClass 'Shaman'
    rarity 'Free'
    formats 'standard'
    association :collection
    association :player
    craft true

    trait :wild_card do
      formats 'wild'
    end
  end
end
