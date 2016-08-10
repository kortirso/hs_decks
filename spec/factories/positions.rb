FactoryGirl.define do
    factory :position_for_user, class: 'Position' do
        amount 1
        association :card
        association :positionable, factory: :user
    end
    factory :position_for_deck, class: 'Position' do
        amount 1
        association :card
        association :positionable, factory: :deck
    end
    factory :position_for_check, class: 'Position' do
        amount 1
        association :card
        association :positionable, factory: :check
    end
end
