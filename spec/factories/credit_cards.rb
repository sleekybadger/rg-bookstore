FactoryGirl.define do
  factory :credit_card do
    number { Faker::Number.number(16) }
    expiration_month { 3 }
    expiration_year { Time.now.year + 1 }
    cvv { Faker::Number.number(3) }
  end
end
