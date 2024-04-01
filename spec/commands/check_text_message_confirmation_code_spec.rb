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

    it "increments the players confirmation_code_attempts" do
      player = create :player, confirmation_code: "123456"

      expect {
        CheckTextMessageConfirmationCode.check?(
          player: player,
          attempted_confirmation_code: "000000",
        )
      }.to change { player.confirmation_code_attempts }.from(0).to(1)
    end

    describe "after 5 incorrect confirmation code attempts" do
      it "sets the players confirmation code to empty string" do
        player = create :player,
          confirmation_code: "123456",
          confirmation_code_attempts: 3

        expect {
          CheckTextMessageConfirmationCode.check?(
            player: player,
            attempted_confirmation_code: "000000",
          )
        }.to change { player.confirmation_code }.from("123456").to("")
      end

      it "sets the players confirmation attempts to 0" do
        player = create :player,
          confirmation_code: "123456",
          confirmation_code_attempts: 3

        expect {
          CheckTextMessageConfirmationCode.check?(
            player: player,
            attempted_confirmation_code: "000000",
          )
        }.to change { player.confirmation_code_attempts }.from(3).to(0)
      end
    end
  end

  describe "with the correct confirmation code" do
    describe "when the confirmation code is blank/unset" do
      it "returns false" do
        player = create :player, confirmation_code: ""

        expect(CheckTextMessageConfirmationCode.check?(
            player: player,
            attempted_confirmation_code: "",
        )).to eq(false)
      end
    end

    it "returns true" do
      player = create :player, confirmation_code: "123456"

      expect(CheckTextMessageConfirmationCode.check?(
          player: player,
          attempted_confirmation_code: "123456",
      )).to eq(true)
    end

    it "sets the players confirmation code to empty string" do
      player = create :player, confirmation_code: "123456"

      expect {
        CheckTextMessageConfirmationCode.check?(
          player: player,
          attempted_confirmation_code: "123456",
        )
      }.to change { player.confirmation_code }.from("123456").to("")
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
