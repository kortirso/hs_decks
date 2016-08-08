FactoryGirl.define do
    factory :deck do
        name 'First deck'
        playerClass 'Shaman'
        formats 'standard'
        association :user
    end
end
