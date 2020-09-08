FactoryBot.define do
  factory :notification do
    association :user
    destination_id { 1 }
    follow_id { 1 }
    variety { 1 }
    content { "" }
    from_user_id { 2 }
  end
end
