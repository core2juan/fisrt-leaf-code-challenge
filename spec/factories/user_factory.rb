FactoryBot.define do
  factory :user do
    sequence(:full_name) { |n| "Foo Bar #{n}" }

    trait :valid do
      sequence(:email)          { |n| "email#{n}@example.com" }
      sequence(:key)            { |n| "#{n}" }
      sequence(:account_key)    { |n| "#{n}" }
      sequence(:password)       { |n| "#{n}" }
      sequence(:phone_number)   { |n| "#{n}" }
    end
  end
end
