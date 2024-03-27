require "rails_helper"

describe GameSerializer do
  describe "self.serialize(game)" do
    it "serializes games" do
      player_1 = create :player
      player_2 = create :player

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
        players: [
          PlayerSerializer.serialize(player_1),
          PlayerSerializer.serialize(player_2),
        ],
        ids_of_players_who_responded_yes_to_attending: [],
        ids_of_players_who_responded_no_to_attending: [],
        ids_of_players_who_responded_maybe_to_attending: [],
      })

      expect(GameSerializer.serialize(away_game)).to eq({
        id: away_game.id,
        played_at: away_game.played_at.iso8601,
        is_home_team: false,
        rink: "Rink B",
        opposing_teams_name: "The Einsteins",
        goals_for: 1,
        goals_against: 2,
        players: [
          PlayerSerializer.serialize(player_1),
          PlayerSerializer.serialize(player_2),
        ],
        ids_of_players_who_responded_yes_to_attending: [],
        ids_of_players_who_responded_no_to_attending: [],
        ids_of_players_who_responded_maybe_to_attending: [],
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
          players: [],
          ids_of_players_who_responded_no_to_attending: [],
          ids_of_players_who_responded_yes_to_attending: [],
          ids_of_players_who_responded_maybe_to_attending: [],
        })
      end
    end
  end
end
