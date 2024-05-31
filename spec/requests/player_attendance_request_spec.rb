require "rails_helper"

describe "POST requests to /teams/:team_id/games/:id/player_attendance" do
  describe "without an authenticated user" do
    it "responds with an unauthorized response" do
      team = create :team
      game = create :game, team: team

      post "/teams/#{team.id}/games/#{game.id}/player_attendance"

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "with an authenticated player who doesn't play for the team that has the game" do
    it "responds with a not found response" do
      player = create :player
      team = create :team
      game = create :game, team: team

      post "/teams/#{team.id}/games/#{game.id}/player_attendance",
        headers: { "ApiToken" => player.api_token }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "with an authenticated user" do
    it "returns a 201 created response" do
      team = create :team
      player = create :player, teams: [team]
      game = create :game, team: team

      post "/teams/#{team.id}/games/#{game.id}/player_attendance",
        headers: { "ApiToken" => player.api_token }

      expect(response).to have_http_status(:created)
    end

    it "saves the players response" do
      allow(CreateOrUpdatePlayerAttendance).to receive(:create_or_update)

      team = create :team
      game = create :game, team: team
      player = create :player, teams: [team]

      post "/teams/#{team.id}/games/#{game.id}/player_attendance",
        headers: { "ApiToken" => player.api_token },
        params: { "attending" => "Yes" }

      expect(CreateOrUpdatePlayerAttendance).to have_received(
        :create_or_update
      ).with(game_id: game.id, player_id: player.id, attending: "Yes")
    end
  end
end
