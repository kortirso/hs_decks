FactoryGirl.define do
    factory :check do
        success 90
        association :user
        association :deck
    end
end
