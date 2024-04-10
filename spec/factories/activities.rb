FactoryBot.define do
  factory :activity do
    address { Faker::Address.street_address }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
    type { Faker::Sport.sport(include_ancient: true) }
    expenses { Faker::Number.between(from: 0, to: 500) }
    rating { Faker::Number.between(from: 2.0, to: 5.0) }
  end
end
