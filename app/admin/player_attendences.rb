ActiveAdmin.register PlayerAttendance do
  permit_params :game, :player, :attending

  index do
    id_column
    column :game
    column :player
    column :attending
  end
end

class PlayerAttendance < ApplicationRecord
  def display_name
    "#{player.display_name} responded #{attending} to attending #{game.display_name}"
  end
end
