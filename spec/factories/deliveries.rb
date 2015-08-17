FactoryGirl.define do
  factory :delivery do
    name { Faker::App.name }
    price { Faker::Commerce.price }
  end
end
