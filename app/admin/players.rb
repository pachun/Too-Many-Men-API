ActiveAdmin.register Player do
  permit_params :first_name, :last_name, :jersey_number, :phone_number
end

class Player < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    @ransackable_attributes ||= column_names + _ransackers.keys + _ransack_aliases.keys + attribute_aliases.keys
  end

  def display_name
    "#{first_name} #{last_name}"
  end
end
