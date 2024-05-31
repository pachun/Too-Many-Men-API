require "rails_helper"

describe Player, type: :model do
  subject { create :player }

  it { should validate_presence_of(:phone_number) }
  it { should validate_uniqueness_of(:phone_number).case_insensitive }
  it { should validate_presence_of(:api_token) }
  it { should validate_uniqueness_of(:api_token) }
end
