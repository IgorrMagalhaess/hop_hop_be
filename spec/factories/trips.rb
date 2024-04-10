FactoryBot.define do
   factory :trip do
      name { Faker::Name.name }
      location { Faker::Address.country }
      start_date { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
      end_date { Faker::Time.between(from: DateTime.now + 1, to: DateTime.now + 3) }
      status { Faker::Number.between(from: 0, to: 1) }
      total_budget { Faker::Number.between(from: 500, to: 10000) }
      user_id { nil }
   end
end