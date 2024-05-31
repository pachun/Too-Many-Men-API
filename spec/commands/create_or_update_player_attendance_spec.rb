require "rails_helper"

describe CreateOrUpdatePlayerAttendance do
  describe "self.create_or_update(game_id:, player_id: attending:)" do
    it "creates the players attendance response" do
      game = create :game
      player = create :player, phone_number: "0123456789"

      CreateOrUpdatePlayerAttendance.create_or_update(
        game_id: game.id,
        player_id: player.id,
        attending: "Yes",
      )

      expect(PlayerAttendance.last).to have_attributes(
        game: game,
        player: player,
        attending: "Yes",
      )
    end

    describe "when the player attendance record already exists" do
      it "updates the existing player attendance response" do
        game = create :game
        player = create :player, phone_number: "0123456789"

        PlayerAttendance.create(game: game, player: player, attending: "Yes")

        CreateOrUpdatePlayerAttendance.create_or_update(
          game_id: game.id,
          player_id: player.id,
          attending: "Maybe",
        )

        expect(PlayerAttendance.find_by(
          game: game,
          player: player,
        ).attending).to eq("Maybe")
      end
    end
  end
end
