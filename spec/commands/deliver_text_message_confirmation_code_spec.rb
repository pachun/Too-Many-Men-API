require "rails_helper"

describe DeliverTextMessageConfirmationCode do
  describe "self.deliver(player_id:)" do
    it "saves the users confirmation code" do
      player = create :player

      allow(ConfirmationCodeGenerator).to receive(:generate)
        .and_return("123456")

      DeliverTextMessageConfirmationCode.deliver(player_id: player.id)

      expect(player.reload.confirmation_code).to eq("123456")

      allow(ConfirmationCodeGenerator).to receive(:generate)
        .and_return("654321")

      DeliverTextMessageConfirmationCode.deliver(player_id: player.id)

      expect(player.reload.confirmation_code).to eq("654321")
    end
  end
end
