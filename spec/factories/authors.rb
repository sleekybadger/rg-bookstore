FactoryGirl.define do
  sequence :author_bio do |n|
    if n.odd?
      Faker::Lorem.paragraph
    else
      ''
    end
  end

  factory :author do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    biography { FactoryGirl.generate(:author_bio) }
  end
end
