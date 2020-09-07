FactoryBot.define do
  factory :comment do
    content { "私も行ってみたいです" }
    association :user
    association :destination
  end
end
