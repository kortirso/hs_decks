FactoryGirl.define do
    factory :pack do
        amount 1
        association :user
        association :card
    end
end