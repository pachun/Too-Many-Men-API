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
    }
  end
end
