# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :listing do
    split_type 1
    seller_id 1
    buyer_id 1
    status 1
    tickets_count 1
    event_id 1
  end
end
