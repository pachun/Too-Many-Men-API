require "rails_helper"

describe InvitePlayerToTeam do
  describe "self.invite(first_name:, last_name:, phone_number:)" do
    it "creates the player" do
      allow(TwilioService).to receive(:text)
      allow(SecureRandom).to receive(:alphanumeric)
        .with(32)
        .and_return("API Token")

      InvitePlayerToTeam.invite(
        team: (create :team),
        first_name: "Kevin",
        last_name: "Malone",
        phone_number: "0123456789",
        inviting_player: (create :player),
      )

      expect(Player.find_by(phone_number: "0123456789")).to have_attributes(
        first_name: "Kevin",
        last_name: "Malone",
        api_token: "API Token",
      )
    end

    it "adds the player to the team" do
      allow(TwilioService).to receive(:text)
      team = create :team

      InvitePlayerToTeam.invite(
        team: team,
        first_name: "Kevin",
        last_name: "Malone",
        phone_number: "0123456789",
        inviting_player: (create :player),
      )

      expect(Player.find_by(phone_number: "0123456789").teams).to include(team)
    end

    it "sends a text message to the invited player" do
      allow(TwilioService).to receive(:text)
      allow(SecureRandom).to receive(:alphanumeric)
        .with(32)
        .and_return("API Token")

      inviting_player = create :player,
        first_name: "Phyllis",
        last_name: "Lapin-Vance"

      team = create :team,
        name: "The Einsteins"

      InvitePlayerToTeam.invite(
        team: team,
        first_name: "Kevin",
        last_name: "Malone",
        phone_number: "0123456789",
        inviting_player: inviting_player,
      )

      expect(TwilioService).to have_received(:text).with(
        message: "Phyllis Lapin-Vance invited you to join The Einsteins in the Too Many Men App. #{Rails.application.credentials.web_app_base_url}/teams/#{team.id}",
        to: "0123456789",
      )
    end

    describe "when the player already exists" do
      it "does not create a player" do
        allow(TwilioService).to receive(:text)
        player = create :player,
          first_name: "Kevin",
          last_name: "Malone",
          phone_number: "0123456789"

        inviting_player = create :player

        expect {
          InvitePlayerToTeam.invite(
            team: (create :team),
            first_name: "Kevin",
            last_name: "Malone",
            phone_number: "0123456789",
            inviting_player: inviting_player,
          )
        }.not_to change {
          Player.count
        }
      end

      it "adds the player to the team" do
        allow(TwilioService).to receive(:text)
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
          inviting_player: (create :player),
        )

        expect(player.reload.teams).to include(team)
      end
    end
  end
end
