FactoryBot.define do
  factory :player do
    sequence :first_name do |ascending_number|
      "factory_generated_player_first_name_#{ascending_number}"
    end
    sequence :last_name do |ascending_number|
      "factory_generated_player_last_name_#{ascending_number}"
    end
    team { create :team }
  end
end
