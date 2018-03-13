FactoryBot.define do
  factory :race do
    sequence(:name) { |i| { en: "Murloc_#{i}", ru: "Мурлок_#{i}" } }
  end
end
