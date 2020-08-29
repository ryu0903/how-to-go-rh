FactoryBot.define do
  factory :destination do
    to { Faker::Address.city }
    from { Faker::Address.city }
    time "1 hour"
    date "2020-08-27"
    outline "行き方についてです"
    detail "飛行機で行きます"
    notice "早めに空港にいきましょう"
    reference "https://www.skyscanner.jp/"
    association :user
    created_at { Time.current }
  end
  
    trait :yesterday do
      created_at { 1.day.ago }
    end
    
    trait :one_week_ago do
      created_at { 1.week.ago }
    end
    
    trait :one_month_ago do
      created_at { 1.month.ago }
    end
      
end
