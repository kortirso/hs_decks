FactoryGirl.define do
    factory :deck do
        name 'First deck'
        playerClass 'Shaman'
        formats 'standard'
        author ''
        association :user
    end
end
