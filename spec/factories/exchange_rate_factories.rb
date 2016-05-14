FactoryGirl.define do
  factory :exchange_rate do
    sequence(:date) { |n| Date.today - n.days }
    eur_value { rand(10..100).to_f / 100 }
  end
end
