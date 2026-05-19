FactoryBot.define do
  factory :task do
    title { "課題１" }
    description { "課題１の説明" }
    status { :not_started }
    due_date { Date.current + 1.day }
    user { association :user }
  end
end
