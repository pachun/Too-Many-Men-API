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
      first_name: player.first_name,
      last_name: player.last_name,
      jersey_number: player.jersey_number,
      phone_number: player.phone_number,
    }.delete_if{ |k,v| v.nil? }
  end
end
