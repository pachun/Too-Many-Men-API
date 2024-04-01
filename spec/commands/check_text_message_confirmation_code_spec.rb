require "rails_helper"

describe CheckTextMessageConfirmationCode do
  describe "with an incorrect confirmation code" do
    it "returns false" do
      player = create :player, confirmation_code: "123456"

      expect(CheckTextMessageConfirmationCode.check?(
          player: player,
          attempted_confirmation_code: "000000",
      )).to eq(false)
    end
  end

  describe "with the correct confirmation code" do
    it "returns true" do
      player = create :player, confirmation_code: "123456"

      expect(CheckTextMessageConfirmationCode.check?(
          player: player,
          attempted_confirmation_code: "123456",
      )).to eq(true)
    end

    describe "when the player does not have an api token" do
      it "assigns the player an api token" do
        player = create :player, confirmation_code: "123456"

        allow(SecureRandom).to receive(:alphanumeric)
          .with(32)
          .and_return("faked_api_token")

        expect {
          CheckTextMessageConfirmationCode.check?(
            player: player,
            attempted_confirmation_code: "123456",
          )
        }.to change { player.api_token }.from(nil).to("faked_api_token")
      end
    end

    describe "when the player already has an api token" do
      it "does not change the players api token" do
        player = create :player, confirmation_code: "123456", api_token: "api token"

        expect {
          CheckTextMessageConfirmationCode.check?(
            player: player,
            attempted_confirmation_code: "123456",
          )
        }.not_to change { player.api_token }
      end
    end
  end
end
