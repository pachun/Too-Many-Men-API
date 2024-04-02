FactoryBot.define do
  factory :game do
    played_at { "2024-02-10 01:56:55" }
    team { create :team }
  end
end
