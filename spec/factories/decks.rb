FactoryGirl.define do
    factory :deck do
        name 'First deck'
        playerClass 'Shaman'
        formats 'standard'
        author ''
        price 5000
        power 1
        association :user
        association :player
        association :style
    end
end
