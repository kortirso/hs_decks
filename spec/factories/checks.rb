FactoryBot.define do
    factory :check do
        success 0
        association :user
        association :deck
    end
end
