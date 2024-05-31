require 'rails_helper'

describe PlayerAttendance, type: :model do
  it "disallows multiples with the same player/game pair" do
    player = create :player, phone_number: "0123456789"
    game = create :game

    original = create :player_attendance, player: player, game: game

    expect(original).to be_valid

    multiple = build :player_attendance, player: player, game: game

    expect(multiple).not_to be_valid
  end
end
