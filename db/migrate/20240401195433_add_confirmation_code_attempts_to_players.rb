class AddConfirmationCodeAttemptsToPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :confirmation_code_attempts, :integer, null: false, default: 0
  end
end
