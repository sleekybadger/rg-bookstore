FactoryGirl.define do
  factory :address, :class => 'Shopper::Address' do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    city { Faker::Address.city }
    street { Faker::Address.street_address }
    phone { Faker::Base.numerify('+##########') }
    zip { Faker::Address.zip.to_i }

    country

    factory :billing_address, class: 'Shopper::BillingAddress' do
      association :addressable, factory: :address
    end

    factory :shipping_address, class: 'Shopper::ShippingAddress' do
      association :addressable, factory: :address
    end
  end

end