# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ticket do
    event_id 1
    section "MyString"
    row "MyString"
    seat "MyString"
    order_id 1
    listing_id 1
    unit_price "9.99"
  end
end
