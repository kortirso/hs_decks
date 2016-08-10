FactoryGirl.define do
    factory :collection do
        name 'Basic'
        formats 'standard'

        trait :wild_collection do
            formats 'wild'
        end
    end
end
