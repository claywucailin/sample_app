# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    title "MyTitle"
    description "MyText"
    tag_list "music"
  end
end
