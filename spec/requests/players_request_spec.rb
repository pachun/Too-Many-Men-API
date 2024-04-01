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

describe "GET requests to /players/:id", type: :request do
  it "returns the player who has the given id" do
    player_id = "1"
    player_double = double
    allow(Player).to receive(:find).with(player_id).and_return(player_double)
    allow(PlayerSerializer).to receive(:serialize)
      .with(player_double)
      .and_return({ serialized: "player_double" })

    get "/players/#{player_id}"

    received_player = JSON.parse(response.body)

    expect(received_player).to eq({ "serialized" => "player_double" })
  end
end

describe "GET requests to /players/:id/send_text_message_confirmation_code", type: :request do
  it "sends the user a text message confirmation code to confirm their identity" do
    player = create :player

    allow(DeliverTextMessageConfirmationCode).to receive(:deliver)

    get "/players/#{player.id}/send_text_message_confirmation_code"

    expect(DeliverTextMessageConfirmationCode).to have_received(:deliver)
      .with(player_id: "#{player.id}")
  end
end

describe "POST requests to /players/:id/check_text_message_confirmation_code?confirmation_code=:confirmation_code" do
  describe "with an incorrect confirmation code" do
    it "returns a json response of { status: 'incorrect' }" do
      player = create :player, confirmation_code: "123456"

      allow(CheckTextMessageConfirmationCode).to receive(:check?).with(
        player: player,
        attempted_confirmation_code: "000000",
      ).and_return(false)

      post "/players/#{player.id}/check_text_message_confirmation_code?confirmation_code=000000"

      expect(JSON.parse(response.body)).to eq({ "status" => "incorrect" })
    end
  end

  describe "with the correct confirmation code" do
    it "returns a json response of { status: 'correct', api_token: player.api_token }" do
      player = create :player, confirmation_code: "123456", api_token: "api_token"

      allow(CheckTextMessageConfirmationCode).to receive(:check?).with(
        player: player,
        attempted_confirmation_code: "123456",
      ).and_return(true)

      post "/players/#{player.id}/check_text_message_confirmation_code?confirmation_code=123456"

      expect(JSON.parse(response.body)).to eq({
        "status" => "correct",
        "api_token" => "api_token",
      })
    end
  end
end
