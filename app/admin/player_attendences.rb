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
  def self.ransackable_attributes(auth_object = nil)
    @ransackable_attributes ||= column_names + _ransackers.keys + _ransack_aliases.keys + attribute_aliases.keys
  end

  def self.ransackable_associations(auth_object = nil)
    reflect_on_all_associations.map { |a| a.name.to_s } + _ransackers.keys
  end
end
