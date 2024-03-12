class DeliverTextMessageConfirmationCode
  def self.deliver(player_id:)
    Player.find(player_id).update(confirmation_code: ConfirmationCodeGenerator.generate)
  end
end
