FactoryGirl.define do
  sequence :category_title do |n|
    "#{Faker::Lorem.word} #{n}"
  end

  factory :category do
    title { FactoryGirl.generate(:category_title) }
  end
end
