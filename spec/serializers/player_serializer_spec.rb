require "rails_helper"

describe PlayerSerializer do
  describe "self.serialize(player)" do
    it "serializes players" do
      kevin = create :player,
        first_name: "Kevin",
        last_name: "Malone",
        jersey_number: 1,
        phone_number: "0123456789"
      angela = create :player,
        first_name: "Angela",
        last_name: "Martin",
        jersey_number: 2,
        phone_number: "9876543210"

      expect(PlayerSerializer.serialize(kevin)).to eq({
        id: kevin.id,
        first_name: "Kevin",
        last_name: "Malone",
        jersey_number: 1,
        phone_number: "0123456789",
      })
      expect(PlayerSerializer.serialize(angela)).to eq({
        id: angela.id,
        first_name: "Angela",
        last_name: "Martin",
        jersey_number: 2,
        phone_number: "9876543210",
      })
    end

    describe "when the player does not have a jersey number" do
      it "does not serialize a jersey number attribute" do
        kevin = create :player, first_name: "Kevin", last_name: "Malone"

        expect(PlayerSerializer.serialize(kevin)).to eq({
          id: kevin.id,
          first_name: "Kevin",
          last_name: "Malone",
        })
      end
    end
  end
end
