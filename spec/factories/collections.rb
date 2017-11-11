FactoryBot.define do
    factory :collection do
        name_en 'Basic'
        name_ru 'Базовый набор'
        formats 'standard'
        adventure false

        trait :wild_collection do
            formats 'wild'
        end
    end
end
