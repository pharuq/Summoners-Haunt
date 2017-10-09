User.create!(name:  "Example User",
             email: "pharuq2@hotmail.co.jp",
             password:              "foobar",
             password_confirmation: "foobar",
             role: "adc",
             profile: "TEST",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

30.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               role: "#{n} role",
               profile: "#{n} profile",
               activated: true,
               activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
50.times do |n|
  title = "#{n+1} title"
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.diaries.create!(title: title, content: content) }
end

# リレーションシップ
users = User.all
user = users.first
follow = users[2..50]
follow.each { |followed| user.follow(followed)}
