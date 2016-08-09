FactoryGirl.define do
    factory :line do
        success 'full'
        association :check
        association :card
    end
end
