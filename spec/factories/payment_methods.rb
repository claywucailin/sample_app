# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment_method do
    payment_type 1
    payment_details "MyText"
    info_confirmed false
    agreement_confirmed false
    payable_id 1
    payable_type "MyString"
  end
end
