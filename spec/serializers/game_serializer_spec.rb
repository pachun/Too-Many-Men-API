require "rails_helper"

describe GameSerializer do
  describe "self.serialize(game)" do
    it "serializes games" do
      now = DateTime.current
      away_game = create :game,
        played_at: now + 2.days,
        is_home_team: false,
        rink: "Rink B",
        opposing_teams_name: "The Einsteins",
        goals_for: 1,
        goals_against: 2

      expect(GameSerializer.serialize(away_game)).to eq({
        id: away_game.id,
        played_at: away_game.played_at.iso8601,
        is_home_team: false,
        rink: "Rink B",
        opposing_teams_name: "The Einsteins",
        goals_for: 1,
        goals_against: 2,
        players: [],
        ids_of_players_who_responded_yes_to_attending: [],
        ids_of_players_who_responded_no_to_attending: [],
        ids_of_players_who_responded_maybe_to_attending: [],
      })
    end

    it "serializes games players" do
      team = create :team

      player_1 = create :player, phone_number: "0123456789"
      player_2 = create :player, phone_number: "9876543210"

      create :team_player, team: team, player: player_1
      create :team_player, team: team, player: player_2

      game = create :game, team: team

      expect(GameSerializer.serialize(game)).to include(
        players: [
          PlayerSerializer.serialize(player_1),
          PlayerSerializer.serialize(player_2),
        ]
      )
    end

    it "serializes players rsvps" do
      game = create :game

      player_going_to_game = create :player, phone_number: "0123456789"
      create :player_attendance,
        game: game,
        player: player_going_to_game,
        attending: "Yes"

      player_not_going_to_game = create :player, phone_number: "9876543210"
      create :player_attendance,
        game: game,
        player: player_not_going_to_game,
        attending: "No"

      player_maybe_going_to_game = create :player, phone_number: "1111111111"
      create :player_attendance,
        game: game,
        player: player_maybe_going_to_game,
        attending: "Maybe"

      serialized_game = GameSerializer.serialize(game)

      expect(
        serialized_game[:ids_of_players_who_responded_yes_to_attending]
      ).to eq([player_going_to_game.id])

      expect(
        serialized_game[:ids_of_players_who_responded_no_to_attending]
      ).to eq([player_not_going_to_game.id])

      expect(
        serialized_game[:ids_of_players_who_responded_maybe_to_attending]
      ).to eq([player_maybe_going_to_game.id])
    end

    describe "when the game does not have an opposing_teams_name attribute" do
      it "does not serialize an opposing_teams_name value" do
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
