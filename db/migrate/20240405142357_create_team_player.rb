class CreateTeamPlayer < ActiveRecord::Migration[7.1]
  def change
    create_table :team_players do |t|
      t.references :team, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end

    remove_column :players, :team_id
  end
end
