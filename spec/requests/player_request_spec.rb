require "rails_helper"

describe "GET requests to /players", type: :request do
  it "returns all the players" do
    kevin = create :player,
      name: "Kevin Malone",
      jersey_number: 1,
      phone_number: "0123456789"
    angela = create :player,
      name: "Angela Martin",
      jersey_number: 2,
      phone_number: "9876543210"

    get "/players"

    players = JSON.parse(response.body)

    expect(players).to eq([{
      "id" => kevin.id,
      "name" => "Kevin Malone",
      "jersey_number" => 1,
      "phone_number" => "0123456789",
    }, {
      "id" => angela.id,
      "name" => "Angela Martin",
      "jersey_number" => 2,
      "phone_number" => "9876543210",
    }])
  end

  describe "when the player does not have a number" do
    it "does not return a jersey number attribute" do
      kevin = create :player, name: "Kevin Malone"

      get "/players"

      players = JSON.parse(response.body)

      expect(players).to eq([{
        "id" => kevin.id,
        "name" => "Kevin Malone",
      }])
    end
  end
end
