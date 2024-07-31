require "rails_helper"

describe InvitePlayerToTeam do
  describe "self.invite(first_name:, last_name:, phone_number:)" do
    it "creates the player" do
      allow(SecureRandom).to receive(:alphanumeric)
        .with(32)
        .and_return("API Token")

      InvitePlayerToTeam.invite(
        team: (create :team),
        first_name: "Kevin",
        last_name: "Malone",
        phone_number: "0123456789",
      )

      expect(Player.find_by(phone_number: "0123456789")).to have_attributes(
        first_name: "Kevin",
        last_name: "Malone",
        api_token: "API Token",
      )
    end

    it "adds the player to the team" do
      team = create :team

      InvitePlayerToTeam.invite(
        team: team,
        first_name: "Kevin",
        last_name: "Malone",
        phone_number: "0123456789",
      )

      expect(Player.find_by(phone_number: "0123456789").teams).to include(team)
    end

    describe "when the player already exists" do
      it "does not create a player" do
        player = create :player,
          first_name: "Kevin",
          last_name: "Malone",
          phone_number: "0123456789"

        expect {
          InvitePlayerToTeam.invite(
            team: (create :team),
            first_name: "Kevin",
            last_name: "Malone",
            phone_number: "0123456789",
          )
        }.not_to change {
          Player.count
        }
      end

      it "adds the player to the team" do
        team = create :team
        player = create :player,
          first_name: "Kevin",
          last_name: "Malone",
          phone_number: "0123456789"

        InvitePlayerToTeam.invite(
          team: team,
          first_name: "Kevin",
          last_name: "Malone",
          phone_number: "0123456789",
        )

        expect(player.reload.teams).to include(team)
      end
    end
  end
end
