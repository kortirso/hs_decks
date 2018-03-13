FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "tester#{i}@gmail.com" }
    sequence(:username) { |i| "tester_#{i}" }
    password 'password'
    role 'user'

    trait :deck_master do
      role 'deck_master'
    end
  end
end
