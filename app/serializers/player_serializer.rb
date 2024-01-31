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
      jersey_number: player.jersey_number,
    }.delete_if{ |k,v| v.nil? }
  end
end
