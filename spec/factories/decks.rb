FactoryGirl.define do
    factory :deck do
        name 'First deck'
        playerClass 'Shaman'
        formats 'standard'
        author ''
        price 5000
        association :user
    end
end
