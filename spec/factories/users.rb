FactoryGirl.define do
  sequence :user_email do |n|
    "#{n}#{Faker::Internet.email}"
  end

  factory :user do
    email { FactoryGirl.generate(:user_email) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { Faker::Internet.password }
    provider { '' }
    uid { '' }
  end
end
