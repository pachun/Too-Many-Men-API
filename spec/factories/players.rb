FactoryBot.define do
  factory :player do
    sequence :name do |ascending_number|
      "factory_generated_player_name_#{ascending_number}"
    end
  end
end
