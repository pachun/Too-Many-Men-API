require "rails_helper"

describe "GET requests to /players", type: :request do
  it "returns all the players names" do
    kevin = create :player, name: "Kevin Malone"
    angela = create :player, name: "Angela Martin"

    get "/players"

    players = JSON.parse(response.body)

    expect(players).to eq([{
      "id" => kevin.id,
      "name" => "Kevin Malone",
    }, {
      "id" => angela.id,
      "name" => "Angela Martin",
    }])
  end
end
