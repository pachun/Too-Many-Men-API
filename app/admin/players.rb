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
  def display_name
    "#{first_name} #{last_name}"
  end
end
