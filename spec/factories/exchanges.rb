FactoryGirl.define do
    factory :exchange do
        association :position, factory: :position_for_user
        association :card
        must_have false
        priority 5
        max_amount 1

        trait :must_have do
            must_have true
            priority nil
            max_amount nil
        end
    end
end
