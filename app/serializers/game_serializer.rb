class GameSerializer
  def self.serialize(game)
    new(game).serialize
  end

  attr_reader :game

  def initialize(game)
    @game = game
  end

  def serialize
    {
      id: game.id,
      played_at: game.played_at.iso8601,
      is_home_team: game.is_home_team,
      rink: game.rink,
      opposing_teams_name: game.opposing_teams_name,
      goals_for: game.goals_for,
      goals_against: game.goals_against,
      players: Player.all.map do |player|
        PlayerSerializer.serialize(player)
      end,
      ids_of_players_who_responded_yes_to_attending: [],
      ids_of_players_who_responded_no_to_attending: [],
      ids_of_players_who_responded_maybe_to_attending: [],
    }.delete_if{ |k,v| v.nil? }
  end
end
