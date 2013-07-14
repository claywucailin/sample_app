# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :image do
    description "MyString"
    imageable_id 1
    imageable_type "MyString"
    type ""
  end
end
