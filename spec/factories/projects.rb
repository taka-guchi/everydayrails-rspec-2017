FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Test Project #{n}" }
    description { 'Sample project for testing purposes' }
    due_on { 1.week.from_now }
    association :owner

    # 締切日が昨日
    trait :due_yesterday do
      due_on { 1.day.ago }
    end

    # 締切日が今日
    trait :due_today do
      due_on { Date.current.in_time_zone }
    end

    # 締切日が明日
    trait :due_tomorrow do
      due_on { 1.day.from_now }
    end

    # メモ付きのプロジェクト
    trait :with_notes do
      after(:create) { |project| create_list(:note, 5, project: project) }
    end
  end
end
