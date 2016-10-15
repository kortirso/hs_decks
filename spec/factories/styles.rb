FactoryGirl.define do
    factory :style do
        sequence(:name_en) { |i| "Aggro_#{i}" }
        sequence(:name_ru) { |i| "Агро_#{i}" }
    end
end
