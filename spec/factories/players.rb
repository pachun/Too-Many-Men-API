FactoryBot.define do
  digits_in_phone_numbers = 10

  factory :player do
    sequence :first_name do |ascending_number|
      "factory_generated_player_first_name_#{ascending_number}"
    end
    sequence :last_name do |ascending_number|
      "factory_generated_player_last_name_#{ascending_number}"
    end
    sequence :api_token do |ascending_number|
      "factory_generated_player_api_token_#{ascending_number}"
    end
    sequence :phone_number do |ascending_number|
      "#{ascending_number}" * digits_in_phone_numbers
    end
  end
end
