require "rails_helper"

describe "GET requests to /games", type: :request do
  it "returns all the games" do
    game_1_double = double
    game_2_double = double
    games_double = [game_1_double, game_2_double]
    allow(Game).to receive(:all).and_return(games_double)

    serialized_game_1_double = { serialized: "game_1_double" }
    serialized_game_2_double = { serialized: "game_2_double" }
    allow(GameSerializer).to receive(:serialize)
      .with(game_1_double)
      .and_return(serialized_game_1_double)
    allow(GameSerializer).to receive(:serialize)
      .with(game_2_double)
      .and_return(serialized_game_2_double)

    get "/games"

    games = JSON.parse(response.body)

    expect(games).to eq([{
      "serialized" => "game_1_double",
    }, {
      "serialized" => "game_2_double",
    }])
  end
end
