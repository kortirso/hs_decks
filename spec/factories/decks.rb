FactoryGirl.define do
    factory :deck do
        name 'First deck'
        playerClass 'Shaman'
        association :user
    end
end
