class AddApiTokenToPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :api_token, :string
  end
end
