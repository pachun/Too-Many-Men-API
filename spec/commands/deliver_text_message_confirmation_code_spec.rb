require "rails_helper"

describe DeliverTextMessageConfirmationCode do
  describe "self.deliver(phone_number:)" do
    describe "when a player with the given phone number already exists" do
      it "assigns the existing player a text message confirmation code" do
        allow(TwilioService).to receive(:text)

        allow(ConfirmationCodeGenerator).to receive(:generate)
          .and_return("123456")

        player = create :player, phone_number: "0123456789"

        DeliverTextMessageConfirmationCode.deliver(phone_number: "0123456789")

        expect(player.reload.confirmation_code).to eq("123456")
      end

      it "does not change the players api token" do
        allow(TwilioService).to receive(:text)

        allow(ConfirmationCodeGenerator).to receive(:generate)
          .and_return("123456")

        player = create :player, phone_number: "0123456789"

        expect {
          DeliverTextMessageConfirmationCode.deliver(phone_number: "0123456789")
        }.not_to change { player.reload.api_token }

        expect(player.reload.confirmation_code).to eq("123456")
      end
    end

    describe "when a player with the given phone number does not exist" do
      it "creates a player with the given phone number and new api token" do
        allow(TwilioService).to receive(:text)

        allow(SecureRandom).to receive(:alphanumeric)
          .with(32)
          .and_return('new api token')

        expect {
          DeliverTextMessageConfirmationCode.deliver(phone_number: "0123456789")
        }.to change {
          Player.count
        }.from(0).to(1)

        created_player = Player.last

        expect(created_player.phone_number).to eq("0123456789")
        expect(created_player.api_token).to eq("new api token")
        expect(created_player.first_name).to eq("")
        expect(created_player.last_name).to eq("")
      end

      it "assigns the created player a text message confirmation code" do
        allow(TwilioService).to receive(:text)

        allow(ConfirmationCodeGenerator).to receive(:generate)
          .and_return("123456")

        DeliverTextMessageConfirmationCode.deliver(phone_number: "0123456789")

        created_player = Player.last

        expect(created_player.confirmation_code).to eq("123456")
      end
    end

    it "sends the player a text message confirmation code" do
      allow(TwilioService).to receive(:text)

      allow(ConfirmationCodeGenerator).to receive(:generate)
        .and_return("654321")

      DeliverTextMessageConfirmationCode.deliver(phone_number: "9876543210")

      expect(TwilioService).to have_received(:text).with(
        message: "Your Too Many Men App confirmation code is 654321",
        to: "9876543210",
      )
    end

    describe "in the development environment" do
      it "does not send a text message" do
        rails_env_double = instance_double(ActiveSupport::EnvironmentInquirer)
        allow(rails_env_double).to receive(:development?).and_return(true)
        allow(Rails).to receive(:env).and_return(rails_env_double)
        allow(TwilioService).to receive(:text)

        allow(ConfirmationCodeGenerator).to receive(:generate)
          .and_return("654321")

        DeliverTextMessageConfirmationCode.deliver(phone_number: "9876543210")

        expect(TwilioService).not_to have_received(:text)
      end

      it "logs the confirmation code" do
        rails_env_double = instance_double(ActiveSupport::EnvironmentInquirer)
        allow(rails_env_double).to receive(:development?).and_return(true)
        allow(Rails).to receive(:env).and_return(rails_env_double)
        allow(TwilioService).to receive(:text)

        allow(ConfirmationCodeGenerator).to receive(:generate)
          .and_return("654321")

        expect {
          DeliverTextMessageConfirmationCode.deliver(phone_number: "9876543210")
        }.to output("Your Too Many Men App confirmation code is 654321\n").to_stdout
      end
    end
  end
end
