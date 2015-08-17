FactoryGirl.define do
  factory :review do
    note { Faker::Lorem.paragraph.slice(0..499) }
    rating { [*Review::RATING].sample }
    user
    book

    trait :approved do
      status 1
    end

    trait :rejected do
      status 2
    end

    trait :low_rating do
      rating 1
    end
  end
end
