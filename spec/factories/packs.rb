FactoryGirl.define do
    factory :pack do
        association :user
        association :card
    end
end
