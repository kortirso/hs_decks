FactoryGirl.define do
    factory :card do
        cardId 'CS2_041'
        name 'Ancestral Healing'
        type 'Spell'
        cost 0
        playerClass 'Shaman'
        rarity 'Free'
        association :collection
    end
end
