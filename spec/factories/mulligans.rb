FactoryBot.define do
    factory :mulligan do
        association :deck
        association :player
    end
end
