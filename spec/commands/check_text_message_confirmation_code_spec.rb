require "rails_helper"

describe CheckTextMessageConfirmationCode do
  describe "self.check(phone_number:, confirmation_code:)" do
    describe "when no player with the given phone number exists" do
      it "returns :incorrect" do
        expect(
          CheckTextMessageConfirmationCode.check(
            phone_number: "0123456789",
            confirmation_code: "123456",
          )
        ).to eq(:incorrect)
      end
    end

    describe "when the tested confirmation code is empty" do
      it "returns :incorrect" do
        expect(
          CheckTextMessageConfirmationCode.check(
            phone_number: "0123456789",
            confirmation_code: "",
          )
        ).to eq(:incorrect)
      end
    end

    describe "when the confirmation code is correct" do
      it "returns :correct" do
        create :player,
          phone_number: "0123456789",
          confirmation_code: "123456"

        expect(
          CheckTextMessageConfirmationCode.check(
            phone_number: "0123456789",
            confirmation_code: "123456",
          )
        ).to eq(:correct)
      end

      it "does not change the players api token" do
        player = create :player,
          api_token: "api token",
          phone_number: "0123456789",
          confirmation_code: "123456"

        expect {
          CheckTextMessageConfirmationCode.check(
            phone_number: "0123456789",
            confirmation_code: "123456",
          )
        }.not_to change {
          player.reload.api_token
        }
      end

      it "sets the players confirmation code to empty string" do
        player = create :player,
          api_token: "api token",
          phone_number: "0123456789",
          confirmation_code: "123456"

        expect {
          CheckTextMessageConfirmationCode.check(
            phone_number: "0123456789",
            confirmation_code: "123456",
          )
        }.to change { player.reload.confirmation_code }.from("123456").to("")
      end

      it "sets the players confirmation code attempts to 0" do
        player = create :player,
          api_token: "api token",
          phone_number: "0123456789",
          confirmation_code: "123456",
          confirmation_code_attempts: 1

        expect {
          CheckTextMessageConfirmationCode.check(
            phone_number: "0123456789",
            confirmation_code: "123456",
          )
        }.to change { player.reload.confirmation_code_attempts }.from(1).to(0)
      end
    end

    describe "when the confirmation code is incorrect" do
      describe "when the confirmation code is guessed incorrectly 3 times" do
        it "sets the players confirmation code to empty string" do
          player = create :player,
            phone_number: "0123456789",
            confirmation_code: "123456",
            confirmation_code_attempts: 2

          expect {
            CheckTextMessageConfirmationCode.check(
              phone_number: "0123456789",
              confirmation_code: "000000",
            )
          }.to change { player.reload.confirmation_code }.from("123456").to("")
        end

        it "sets the players confirmation code attempts to 0" do
          player = create :player,
            phone_number: "0123456789",
            confirmation_code: "123456",
            confirmation_code_attempts: 2

          expect {
            CheckTextMessageConfirmationCode.check(
              phone_number: "0123456789",
              confirmation_code: "000000",
            )
          }.to change {
            player.reload.confirmation_code_attempts
          }.from(2).to(0)
        end

        it "returns :incorrect_and_unset" do
          player = create :player,
            phone_number: "0123456789",
            confirmation_code: "123456",
            confirmation_code_attempts: 2

          expect(CheckTextMessageConfirmationCode.check(
            phone_number: "0123456789",
            confirmation_code: "000000",
          )).to eq(:incorrect_and_unset)
        end
      end

      it "returns :incorrect" do
        create :player,
          phone_number: "0123456789",
          confirmation_code: "123456"

        expect(
          CheckTextMessageConfirmationCode.check(
            phone_number: "0123456789",
            confirmation_code: "000000",
          )
        ).to eq(:incorrect)
      end

      it "increments the players confirmation_code_attempts" do
        player = create :player,
          phone_number: "0123456789",
          confirmation_code: "123456"

        expect {
          CheckTextMessageConfirmationCode.check(
            phone_number: "0123456789",
            confirmation_code: "000000",
          )
        }.to change { player.reload.confirmation_code_attempts }.from(0).to(1)
      end
    end
  end
end
