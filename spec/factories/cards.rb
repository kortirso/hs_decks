FactoryGirl.define do
    factory :card do
        sequence(:cardId) { |i| "cardId_#{i}" }
        sequence(:name_en) { |i| "name_en_#{i}" }
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
