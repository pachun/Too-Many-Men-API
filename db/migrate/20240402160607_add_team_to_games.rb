class AddTeamToGames < ActiveRecord::Migration[7.1]
  def change
    add_reference :games, :team, null: false, foreign_key: true, default: 1
  end
end
