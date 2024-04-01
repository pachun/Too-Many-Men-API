class CreatePlayerAttendances < ActiveRecord::Migration[7.1]
  def change
    create_table :player_attendances, primary_key: [:game_id, :player_id] do |t|
      t.references :game, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.string :attending

      t.timestamps
    end
  end
end
