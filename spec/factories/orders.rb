# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    buyer_id 1
    shipment_method 1
    shipment_address "MyText"
    payment_date "2013-06-24 00:13:29"
    payment_method 1
    total_amount "9.99"
    shipment_date "2013-06-24 00:13:29"
  end
end
