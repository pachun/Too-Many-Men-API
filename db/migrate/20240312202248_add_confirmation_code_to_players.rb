class AddConfirmationCodeToPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :confirmation_code, :string
  end
end
