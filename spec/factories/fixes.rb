FactoryBot.define do
    factory :fix do
        body_en 'Fix'
        body_ru 'Исправление'
        association :about
    end
end
