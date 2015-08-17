FactoryGirl.define do
  factory :order do
    delivery

    after(:build) do |order|
      order.billing_address ||= FactoryGirl.create :billing_address
      order.shipping_address ||= FactoryGirl.create :shipping_address
      order.credit_card ||= FactoryGirl.create :credit_card
    end

    factory :order_with_items do
      transient { items_count 3 }

      after :create do |order, evaluator|
        create_list(:order_item, evaluator.items_count, order: order)
      end
    end
  end
end
