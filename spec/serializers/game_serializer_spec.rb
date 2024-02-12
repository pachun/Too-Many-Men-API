require "rails_helper"

describe GameSerializer do
  describe "self.serialize(game)" do
    it "serializes games" do
      now = DateTime.current
      home_game = create :game,
        played_at: now - 2.days,
        is_home_team: true

      away_game = create :game,
        played_at: now + 2.days,
        is_home_team: false

      expect(GameSerializer.serialize(home_game)).to eq({
        id: home_game.id,
        played_at: home_game.played_at.iso8601,
        is_home_team: true,
      })

      expect(GameSerializer.serialize(away_game)).to eq({
        id: away_game.id,
        played_at: away_game.played_at.iso8601,
        is_home_team: false,
      })
    end
  end
end