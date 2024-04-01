require "rails_helper"

describe TwilioService do
  describe "self.text(message:, to:)" do
    it "texts the message to the given phone number" do
      twilio_rest_client_double = instance_double(Twilio::REST::Client)
      twilio_message_list_double = instance_double(
        Twilio::REST::Api::V2010::AccountContext::MessageList,
      )
      allow(twilio_rest_client_double).to receive(:messages)
        .and_return(twilio_message_list_double)
      allow(twilio_message_list_double).to receive(:create)

      # -

      allow(Rails.application.credentials).to receive(:twilio).and_return({
        account_sid: "TWILIO_ACCOUNT_SID_1",
        auth_token: "TWILIO_AUTH_TOKEN_1",
        phone_number: "TWILIO_PHONE_NUMBER_1",
      })

      allow(Twilio::REST::Client).to receive(:new).with(
        "TWILIO_ACCOUNT_SID_1",
        "TWILIO_AUTH_TOKEN_1",
      ).and_return(twilio_rest_client_double)

      TwilioService.text(message: "hello", to: "+11234567890")

      expect(twilio_message_list_double).to have_received(:create).with(
        from: "TWILIO_PHONE_NUMBER_1",
        to: "+11234567890",
        body: "hello",
      )

      # -

      allow(Rails.application.credentials).to receive(:twilio).and_return({
        account_sid: "TWILIO_ACCOUNT_SID_2",
        auth_token: "TWILIO_AUTH_TOKEN_2",
        phone_number: "TWILIO_PHONE_NUMBER_2",
      })

      allow(Twilio::REST::Client).to receive(:new).with(
        "TWILIO_ACCOUNT_SID_2",
        "TWILIO_AUTH_TOKEN_2",
      ).and_return(twilio_rest_client_double)

      TwilioService.text(message: "world", to: "+19876543210")

      expect(twilio_message_list_double).to have_received(:create).with(
        from: "TWILIO_PHONE_NUMBER_2",
        to: "+19876543210",
        body: "world",
      )
    end
  end
end
