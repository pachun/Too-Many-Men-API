require "rails_helper"

describe DeliverTextMessageConfirmationCode do
  describe "self.deliver(player_id:)" do
    it "saves the player's confirmation code" do
      player = create :player
      allow(TwilioService).to receive(:text)

      allow(ConfirmationCodeGenerator).to receive(:generate)
        .and_return("123456")

      DeliverTextMessageConfirmationCode.deliver(player_id: player.id)

      expect(player.reload.confirmation_code).to eq("123456")

      allow(ConfirmationCodeGenerator).to receive(:generate)
        .and_return("654321")

      DeliverTextMessageConfirmationCode.deliver(player_id: player.id)

      expect(player.reload.confirmation_code).to eq("654321")
    end

    it "texts the player their confirmation code" do
      allow(TwilioService).to receive(:text)

      player = create :player, phone_number: "0123456789"

      allow(ConfirmationCodeGenerator).to receive(:generate)
        .and_return("123456")

      DeliverTextMessageConfirmationCode.deliver(player_id: player.id)

      expect(TwilioService).to have_received(:text).with(
        message: "Your Wolfpack App confirmation code is 123456",
        to: "0123456789",
      )

      player_with_a_different_phone_number = create :player,
        phone_number: "9876543210"

      allow(ConfirmationCodeGenerator).to receive(:generate)
        .and_return("654321")

      DeliverTextMessageConfirmationCode.deliver(
        player_id: player_with_a_different_phone_number.id,
      )

      expect(TwilioService).to have_received(:text).with(
        message: "Your Wolfpack App confirmation code is 654321",
        to: "9876543210",
      )
    end
  end
end
