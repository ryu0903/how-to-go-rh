FactoryBot.define do
  factory :schedule do
    to { "Tokyo" }
    from { "Okinawa" }
    date { "2019/8/1"}
    time { "3 hours" }
    detail { "very far" }
    notice { "very far" }
    association :destination 
  end
end
