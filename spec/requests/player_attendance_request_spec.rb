require "rails_helper"

describe "POST requests to /games/[game_id]/player_attendance" do
  describe "without an authenticated user" do
    it "returns a 401 unauthorized response" do
      game = create :game

      post "/games/#{game.id}/player_attendance"

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "with an authenticated user" do
    it "returns a 201 created response" do
      game = create :game

      post "/games/#{game.id}/player_attendance"

      expect(response).to have_http_status(:created)
    end

    it "saves the players response" do
      allow(CreateOrUpdatePlayerAttendance).to receive(:create_or_update)

      game = create :game
      player = create :player

      post "/games/#{game.id}/player_attendance",
        headers: { "ApiToken" => player.api_token }

        expect(CreateOrUpdatePlayerAttendance).to have_received(
          :create_or_update
        ).with(game_id: game.id, player_id: player.id)
    end
  end

  describe "with a payload indicating the player will be at the game" do
    it "saves the players response" do
      game = create :game
      player = create :player

      post "/games/#{game.id}/player_attendance",
        headers: { "ApiToken" => player.api_token },
        params: { attending: "Yes" }

      expect(response).to have_http_status(:created)
      expect(PlayerAttendance.find_by(
        player_id: player.id,
        game_id: game.id
      ).attending).to eq("Yes")
    end
  end

  describe "with a payload indicating the player will not be at the game" do
    it "saves the players response" do
      game = create :game
      player = create :player

      post "/games/#{game.id}/player_attendance",
        headers: { "ApiToken" => player.api_token },
        params: { attending: "No" }

      expect(response).to have_http_status(:created)
      expect(PlayerAttendance.find_by(
        player_id: player.id,
        game_id: game.id
      ).attending).to eq("No")
    end
  end

  describe "with a payload indicating the player might be at the game" do
    it "saves the players response" do
      game = create :game
      player = create :player

      post "/games/#{game.id}/player_attendance",
        headers: { "ApiToken" => player.api_token },
        params: { attending: "Maybe" }

      expect(response).to have_http_status(:created)
      expect(PlayerAttendance.find_by(
        player_id: player.id,
        game_id: game.id
      ).attending).to eq("Maybe")
    end
  end
end
