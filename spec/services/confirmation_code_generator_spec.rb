require "rails_helper"

describe ConfirmationCodeGenerator do
  describe "self.generate" do
    it "returns a random six digit code" do
      allow(Kernel).to receive(:rand).with(10).and_return(0)

      expect(ConfirmationCodeGenerator.generate).to eq("000000")

      allow(Kernel).to receive(:rand).with(10).and_return(1)

      expect(ConfirmationCodeGenerator.generate).to eq("111111")
    end
  end
end
