require "rails_helper"

describe GameSerializer do
  describe "self.serialize(game)" do
    it "serializes games" do
      now = DateTime.current
      game = create :game, played_at: now - 2.days

      expect(GameSerializer.serialize(game)).to eq({
        id: game.id,
        played_at: game.played_at.iso8601,
      })
    end
  end
end
