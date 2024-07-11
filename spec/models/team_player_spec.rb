require "rails_helper"

describe TeamPlayer, type: :model do
  subject {
    create :team_player,
      team: (create :team),
      player: (create :player)
  }

  it { should validate_uniqueness_of(:team_id).scoped_to(:player_id) }
end
