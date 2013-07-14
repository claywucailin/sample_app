# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    addressable_id 1
    addressable_type "MyString"
    zipcode "MyString"
    street_address "MyString"
    region_id 1
  end
end
