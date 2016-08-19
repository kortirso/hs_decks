FactoryGirl.define do
    factory :shift do
        priority 10
        association :card
        association :change, factory: :card
    end
end
