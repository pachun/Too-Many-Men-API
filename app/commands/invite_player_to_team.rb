class InvitePlayerToTeam
  def self.invite(team:, first_name:, last_name:, phone_number:)
    new(team, first_name, last_name, phone_number).invite
  end

  attr_reader :team, :first_name, :last_name, :phone_number

  def initialize(team, first_name, last_name, phone_number)
    @team = team
    @first_name = first_name
    @last_name = last_name
    @phone_number = phone_number
  end

  def invite
    TeamPlayer.create(
      player: player,
      team: team,
    )
  end

  private

  def player
    @player ||= existing_player.blank? ? new_player : existing_player
  end

  def existing_player
    @existing_player ||= Player.find_by(phone_number: phone_number)
  end

  def new_player
    @new_player ||= Player.create(
      first_name: first_name,
      last_name: last_name,
      phone_number: phone_number,
      api_token: SecureRandom.alphanumeric(32),
    )
  end
end
