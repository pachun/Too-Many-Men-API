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
