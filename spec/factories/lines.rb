FactoryBot.define do
  factory :line do
    association :deck
    association :card
    max_amount 1
    priority 5
  end
end
