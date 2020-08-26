FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email){ |n| "example#{n}@example.com" }
    password{ "password" }
    password_confirmation{ "password" }
    introduce{ "はじめまして" }
  end
  
  trait :admin do
    admin { true }
  end
end