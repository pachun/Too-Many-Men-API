require "rails_helper"

describe "GET requests to /players", type: :request do
  it "returns all the players" do
    player_1_double = double
    player_2_double = double
    players_double = [player_1_double, player_2_double]
    allow(Player).to receive(:all).and_return(players_double)

    serialized_player_1_double = { serialized: "player_1_double" }
    serialized_player_2_double = { serialized: "player_2_double" }
    allow(PlayerSerializer).to receive(:serialize)
      .with(player_1_double)
      .and_return(serialized_player_1_double)
    allow(PlayerSerializer).to receive(:serialize)
      .with(player_2_double)
      .and_return(serialized_player_2_double)

    get "/players"

    players = JSON.parse(response.body)

    expect(players).to eq([{
      "serialized" => "player_1_double",
    }, {
      "serialized" => "player_2_double",
    }])
  end
end
