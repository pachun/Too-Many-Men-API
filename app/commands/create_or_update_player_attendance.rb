class CreateOrUpdatePlayerAttendance
  def self.create_or_update(game_id:, player_id:, attending:)
    PlayerAttendance.find_or_initialize_by(
      game_id: game_id,
      player_id: player_id,
    ).update(
      attending: attending,
    )
  end
end
