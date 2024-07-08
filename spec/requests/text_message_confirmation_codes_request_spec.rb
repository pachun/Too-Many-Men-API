require "rails_helper"

describe "POST requests to /text_message_confirmation_codes/send" do
  it "sends a text message confirmation code to the given phone number" do
    allow(DeliverTextMessageConfirmationCode).to receive(:deliver)

    post "/text_message_confirmation_codes/deliver",
      params: { phone_number: "0123456789" }

    expect(DeliverTextMessageConfirmationCode).to have_received(:deliver)
      .with(phone_number: "0123456789")
  end
end

describe "POST requests to /text_message_confirmation_codes/check" do
  describe "when the confirmation code is correct" do
    it "returns a json response indicating the confirmation code is correct" do
      player = create :player,
        phone_number: "0123456789"

      allow(CheckTextMessageConfirmationCode).to receive(:check)
        .with(phone_number: "0123456789", confirmation_code: "123456")
        .and_return(:correct)

      post "/text_message_confirmation_codes/check",
        params: { phone_number: "0123456789", confirmation_code: "123456" }

      expect(JSON.parse(response.body)).to eq({
        "correct_confirmation_code" => true,
        "api_token" => player.api_token,
        "player_id" => player.id,
      })
    end
  end

  describe "when the confirmation code is incorrect" do
    it "returns a json response indicating the confirmation code is incorrect" do
      allow(CheckTextMessageConfirmationCode).to receive(:check)
        .with(phone_number: "0123456789", confirmation_code: "123456")
        .and_return(:incorrect)

      post "/text_message_confirmation_codes/check",
        params: { phone_number: "0123456789", confirmation_code: "123456" }

      expect(JSON.parse(response.body)).to eq({
        "correct_confirmation_code" => false,
        "confirmation_code_was_unset" => false,
      })
    end

    describe "when the confirmation code is checked too many times" do
      it "returns a json response indicating the confirmation code was unset" do
        allow(CheckTextMessageConfirmationCode).to receive(:check)
          .with(phone_number: "0123456789", confirmation_code: "123456")
          .and_return(:incorrect_and_unset)

        post "/text_message_confirmation_codes/check",
          params: { phone_number: "0123456789", confirmation_code: "123456" }

        expect(JSON.parse(response.body)).to eq({
          "correct_confirmation_code" => false,
          "confirmation_code_was_unset" => true,
        })
      end
    end
  end
end
