FactoryBot.define do
  factory :user do
    name { "test_name" }
    email { "test@a.com" }
    password { "aaaaaa" }
    admin { false }
  end
end
