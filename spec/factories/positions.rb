FactoryGirl.define do
    factory :position do
        amount 1
        association :deck
        association :card
    end
end
