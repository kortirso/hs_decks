FactoryBot.define do
    factory :exchange do
        association :position, factory: :position_for_user
        association :card
        priority 5
        max_amount 1
    end
end
