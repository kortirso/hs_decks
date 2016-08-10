FactoryGirl.define do
    factory :card do
        sequence(:cardId) { |i| "cardId_#{i}" }
        sequence(:name) { |i| "name_#{i}" }
        type 'Spell'
        cost 0
        playerClass 'Shaman'
        rarity 'Free'
        formats 'standard'
        association :collection

        trait :wild_card do
            formats 'wild'
        end
    end
end
