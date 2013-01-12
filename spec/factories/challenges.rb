# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :challenge do
    question "MyText"
    answer "MyString"
    link "MyString"
  end
end
