class RequirePlayerApiTokens < ActiveRecord::Migration[7.1]
  def change
    change_column :players,
      :api_token,
      :string,
      null: false
  end
end
