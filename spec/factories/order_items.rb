FactoryGirl.define do
  factory :order_item, :class => 'OrderItem' do
    quantity { [*1..10].sample }
    order
    book
  end

end
