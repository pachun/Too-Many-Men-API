require "rails_helper"

describe "GET requests to /teams", type: :request do
  it "returns all the player's teams" do
    player = create :player,
      phone_number: "0123456789"

    team_1 = create :team,
      name: "Scott's Tots"
    create :team_player,
      team: team_1,
      player: player

    team_2 = create :team,
      name: "The Einsteins"
    create :team_player,
      team: team_2,
      player: player

    get "/teams", headers: { "ApiToken" => player.api_token }

    teams = JSON.parse(response.body)

    expect(teams).to eq([{
      "id" => team_1.id,
      "name" => "Scott's Tots",
    }, {
      "id" => team_2.id,
      "name" => "The Einsteins",
    }])
  end

  it "does not return teams for whom the authenticated player does not play" do
    player = create :player,
      phone_number: "0123456789"

    create :team,
      name: "Scott's Tots"

    get "/teams", headers: { "ApiToken" => player.api_token }

    teams = JSON.parse(response.body)

    expect(teams).to eq([])
  end

  describe "with an unauthenticated player" do
    it "returns an unauthorized 403 http status code" do
      get "/teams"

      expect(response).to have_http_status(:unauthorized)
    end
  end
end

describe "GET requests to /teams/:team_id/games/:id", type: :request do
  it "returns the game which has the given id" do
    team = create :team
    player = create :player, teams: [team]
    game = create :game, team: team
    allow(GameSerializer).to receive(:serialize)
      .with(game)
      .and_return({ serialized: "game" })

    get "/teams/#{team.id}/games/#{game.id}", headers: {
      "ApiToken" => player.api_token,
    }

    received_player = JSON.parse(response.body)

    expect(received_player).to eq({ "serialized" => "game" })
  end
end
