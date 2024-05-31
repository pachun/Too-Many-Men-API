require "rails_helper"

describe "GET requests to /games", type: :request do
  it "returns all the games (preloading relations needed by the GameSerializer to avoid N+1 queries)" do
    team = create :team
    player = create :player,
      teams: [team]
    game_1 = create :game,
      team: team
    game_2 = create :game,
      team: team
    games_active_record_relation = instance_double(ActiveRecord::Relation)
    allow(games_active_record_relation).to receive(:includes)
      .with(:player_attendances, :players)
      .and_return([game_1, game_2])

    serialized_game_1 = { serialized: "game_1" }
    allow(GameSerializer).to receive(:serialize)
      .with(game_1)
      .and_return(serialized_game_1)

    serialized_game_2 = { serialized: "game_2" }
    allow(GameSerializer).to receive(:serialize)
      .with(game_2)
      .and_return(serialized_game_2)

    get "/teams/#{team.id}/games", headers: {
      "ApiToken" => player.api_token,
    }

    games = JSON.parse(response.body)

    expect(games).to eq([{
      "serialized" => "game_1",
    }, {
      "serialized" => "game_2",
    }])
  end

  describe "without an authenticated player" do
    it "returns an unauthorized http response" do
      team = create :team

      get "/teams/#{team.id}/games"

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "with an authenticated player requesting games for a team they're not on" do
    it "returns a not found http status" do
      team = create :team
      player = create :player

      get "/teams/#{team.id}/games", headers: {
        "ApiToken" => player.api_token,
      }

      expect(response).to have_http_status(:not_found)
    end
  end
end
