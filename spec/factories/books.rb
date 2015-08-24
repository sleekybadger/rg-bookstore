FactoryGirl.define do
  factory :book do
    title { Faker::Team.name }
    price { Faker::Commerce.price }
    short_description { Faker::Lorem.paragraph.slice(0..499) }
    full_description { Faker::Lorem.paragraph.slice(0..1999) }

    category
    author

    factory :book_with_reviews do
      transient { items_count 3 }

      after :create do |book, evaluator|
        create_list(:review, evaluator.items_count, book: book)
      end
    end

    factory :book_with_review do
      transient { items_count 1 }

      after :create do |book, evaluator|
        evaluator.items_count.times.map { FactoryGirl.create(:review, :low_rating, book: book) }
      end
    end

    factory :book_with_approved_reviews do
      transient { items_count 4 }

      after :create do |book, evaluator|
        evaluator.items_count.times.map { FactoryGirl.create(:review, :approved, book: book) }
      end
    end
  end
end
