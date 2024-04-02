ActiveAdmin.register Player do
  permit_params :first_name, :last_name, :jersey_number, :phone_number

  index do
    id_column
    column :first_name
    column :last_name
    column :phone_number
    column :jersey_number
    column :team
  end
end

class Player < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    @ransackable_attributes ||= column_names + _ransackers.keys + _ransack_aliases.keys + attribute_aliases.keys
  end

  def self.ransackable_associations(auth_object = nil)
    reflect_on_all_associations.map { |a| a.name.to_s } + _ransackers.keys
  end

  def display_name
    "#{first_name} #{last_name}"
  end
end
