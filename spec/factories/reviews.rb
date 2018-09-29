# This will guess the User class
FactoryBot.define do
  factory :review do
    sequence(:store_id) { |n| n }
    sequence(:order_id) { |n| n }
    sequence(:user_id) { |n| n }
    opinion { Faker::Lorem.paragraph }
    score { Review::SCORES.sample }

    trait :last_month do
      created_at { Time.now.last_month }
      updated_at { Time.now.last_month }
    end
  end
end
