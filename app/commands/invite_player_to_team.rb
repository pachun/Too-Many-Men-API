class InvitePlayerToTeam
  def self.invite(
    team:,
    first_name:,
    last_name:,
    phone_number:,
    inviting_player:
  )
    new(team, first_name, last_name, phone_number, inviting_player).invite
  end

  attr_reader :team, :first_name, :last_name, :phone_number, :inviting_player

  def initialize(team, first_name, last_name, phone_number, inviting_player)
    @team = team
    @first_name = first_name
    @last_name = last_name
    @phone_number = phone_number
    @inviting_player = inviting_player
  end

  def invite
    TeamPlayer.create(
      player: player,
      team: team,
    )
    TwilioService.text(
      message: message,
      to: phone_number,
    )
  end

  private

  def message
    @message ||= "#{inviting_player.first_name} #{inviting_player.last_name} invited you to join #{team.name} in the Too Many Men App. #{Rails.application.credentials.web_app_base_url}/teams/#{team.id}"
  end

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
