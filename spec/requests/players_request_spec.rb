require "rails_helper"

describe "GET requests to /teams/:team_id/players", type: :request do
  it "returns all the players" do
    team = create :team
    player_1 = create :player,
      teams: [team]
    player_2 = create :player,
      teams: [team]
    players = [player_1, player_2]

    serialized_player_1 = { serialized: "player_1" }
    serialized_player_2 = { serialized: "player_2" }
    allow(PlayerSerializer).to receive(:serialize)
      .with(player_1)
      .and_return(serialized_player_1)
    allow(PlayerSerializer).to receive(:serialize)
      .with(player_2)
      .and_return(serialized_player_2)

    get "/teams/#{team.id}/players", headers: {
      "ApiToken" => player_1.api_token
    }

    players = JSON.parse(response.body)

    expect(players).to match_array([{
      "serialized" => "player_1",
    }, {
      "serialized" => "player_2",
    }])
  end

  describe "without an authenticated user" do
    it "returns an unauthorized http status" do
      team = create :team

      get "/teams/#{team.id}/players"

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "with an authenticated player requesting players for a team they're not on" do
    it "returns a not found http status" do
      team = create :team
      player = create :player

      get "/teams/#{team.id}/players", headers: {
        "ApiToken" => player.api_token
      }

      expect(response).to have_http_status(:not_found)
    end
  end
end

describe "GET requests to /teams/:team_id/players/:id", type: :request do
  it "returns the player who has the given id" do
    team = create :team
    player = create :player,
      teams: [team]
    allow(PlayerSerializer).to receive(:serialize)
      .with(player)
      .and_return({ serialized: "player" })

    get "/teams/#{team.id}/players/#{player.id}", headers: {
      "ApiToken" => player.api_token,
    }

    received_player = JSON.parse(response.body)

    expect(received_player).to eq({ "serialized" => "player" })
  end
end
