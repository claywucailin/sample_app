# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :performer do
    type ""
    name "MyString"
    aka "MyString"
    profiles "MyText"
    description "MyText"
  end
end
