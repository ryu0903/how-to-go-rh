User.create!(name:  "あづま",
            email: "sample@example.com",
            password:              "foobar",
            password_confirmation: "foobar",
            admin: true)

99.times do |n|
  name = Faker::Name.name
  email = "sample-#{n+1}@example.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end

10.times do |n|
 Destination.create!(
    to: Faker::Address.city,
    from: Faker::Address.city,
    time: "1 hour",
    date: "2020-08-27",
    outline: "行き方についてです",
    detail: "飛行機で行きます",
    notice: "早めに空港にいきましょう",
    reference: "https://www.skyscanner.jp/",
    user_id: 1)
end