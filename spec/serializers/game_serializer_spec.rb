require "rails_helper"

describe GameSerializer do
  describe "self.serialize(game)" do
    it "serializes games" do
      now = DateTime.current
      home_game = create :game,
        played_at: now - 2.days,
        is_home_team: true,
        rink: "Rink A",
        opposing_teams_name: "Scott's Tots",
        goals_for: 3,
        goals_against: 0

      away_game = create :game,
        played_at: now + 2.days,
        is_home_team: false,
        rink: "Rink B",
        opposing_teams_name: "The Einsteins",
        goals_for: 1,
        goals_against: 2

      expect(GameSerializer.serialize(home_game)).to eq({
        id: home_game.id,
        played_at: home_game.played_at.iso8601,
        is_home_team: true,
        rink: "Rink A",
        opposing_teams_name: "Scott's Tots",
        goals_for: 3,
        goals_against: 0,
      })

      expect(GameSerializer.serialize(away_game)).to eq({
        id: away_game.id,
        played_at: away_game.played_at.iso8601,
        is_home_team: false,
        rink: "Rink B",
        opposing_teams_name: "The Einsteins",
        goals_for: 1,
        goals_against: 2,
      })
    end

    describe "when the game is missing optional attributes" do
      it "does not serialize the optional, null-valued attributes" do
        game = create :game,
          played_at: DateTime.current,
          is_home_team: false

        expect(GameSerializer.serialize(game)).to eq({
          id: game.id,
          played_at: game.played_at.iso8601,
          is_home_team: false,
        })
      end
    end
  end
end
