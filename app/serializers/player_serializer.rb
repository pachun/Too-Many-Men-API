class PlayerSerializer
  def self.serialize(player)
    new(player).serialize
  end

  attr_reader :player

  def initialize(player)
    @player = player
  end

  def serialize
    {
      id: player.id,
      name: player.name,
    }
  end
end
