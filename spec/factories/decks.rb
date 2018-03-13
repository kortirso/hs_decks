FactoryBot.define do
  factory :deck do
    sequence(:name) { |i| { en: "Deck #{i}", ru: "Колода #{i}" } }
    playerClass 'Shaman'
    formats 'standard'
    author ''
    price 5000
    power 1
    reno_type false
    association :user
    association :player
    association :style
  end
end
