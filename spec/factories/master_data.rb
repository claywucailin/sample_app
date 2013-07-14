# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :master_datum, :class => 'MasterData' do
    name "MyString"
    description "MyText"
    type ""
  end
end
