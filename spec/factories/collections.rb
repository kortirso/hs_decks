FactoryGirl.define do
    factory :collection do
        name_en 'Basic'
        name_ru 'Базовый набор'
        formats 'standard'

        trait :wild_collection do
            formats 'wild'
        end
    end
end
