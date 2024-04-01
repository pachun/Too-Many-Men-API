class CreateOrUpdatePlayerAttendance
  def self.create_or_update(game_id:, player_id:, attending:)
    new(game_id, player_id, attending).create_or_update
  end

  attr_reader :game_id, :player_id, :attending

  def initialize(game_id, player_id, attending)
    @game_id = game_id
    @player_id = player_id
    @attending = attending
  end

  def create_or_update
    PlayerAttendance.find_or_initialize_by(
      game_id: game_id,
      player_id: player_id,
    ).update(
      attending: attending,
    )
  end
end
