require "rails_helper"

describe Team, type: :model do
  subject { create :team }

  it { should have_many(:team_players).dependent(:destroy) }
end
