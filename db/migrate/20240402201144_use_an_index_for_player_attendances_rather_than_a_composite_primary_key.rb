class UseAnIndexForPlayerAttendancesRatherThanACompositePrimaryKey < ActiveRecord::Migration[7.1]
  def change
    drop_table :player_attendances
    create_table :player_attendances do |t|
      t.string :attending
      t.references :game, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.index ["game_id", "player_id"], name: "index_player_attendances_on_teams_and_players"

      t.timestamps
    end
  end
end
