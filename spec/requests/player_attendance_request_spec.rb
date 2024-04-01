require "rails_helper"

describe "POST requests to /games/:id/player_attendance" do
  describe "without an authenticated user" do
    it "returns a 401 unauthorized response" do
      game = create :game

      post "/games/#{game.id}/player_attendance"

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "with an authenticated user" do
    it "returns a 201 created response" do
      player = create :player
      game = create :game

      post "/games/#{game.id}/player_attendance",
        headers: { "ApiToken" => player.api_token }

      expect(response).to have_http_status(:created)
    end

    it "saves the players response" do
      allow(CreateOrUpdatePlayerAttendance).to receive(:create_or_update)

      game = create :game
      player = create :player

      post "/games/#{game.id}/player_attendance",
        headers: { "ApiToken" => player.api_token },
        params: { "attending" => "Yes" }

        expect(CreateOrUpdatePlayerAttendance).to have_received(
          :create_or_update
        ).with(game_id: game.id, player_id: player.id, attending: "Yes")
    end
  end
end
