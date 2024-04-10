FactoryBot.define do
  factory :accommodation do
    trip_id { Faker::Number.between(from: 0, to: 500) }
    name { Faker::Name.name }
    address { Faker::Address.street }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
    check_in { Faker::Time.between(from: DateTime.now + 1, to: DateTime.now + 3) }
    check_out { Faker::Time.between(from: DateTime.now + 3, to: DateTime.now + 6) }
    type_of_accommodation { Faker::Name.name }
  end
end
