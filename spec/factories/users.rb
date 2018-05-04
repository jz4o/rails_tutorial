FactoryBot.define do
  factory :user do
    name 'TestName'
    email 'TestAddress@test.example.com'
    password 'password'
    password_confirmation 'password'
  end
end
