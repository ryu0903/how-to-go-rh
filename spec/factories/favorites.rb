FactoryBot.define do
  factory :favorite do
    association :user
    association :destination
  end
end
