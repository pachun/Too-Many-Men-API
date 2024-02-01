ActiveAdmin.register Player do
  permit_params :first_name, :last_name, :jersey_number, :phone_number
end

class Player < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    [
      "id",
      "id_value",
      "created_at",
      "updated_at",
      "first_name",
      "last_name",
      "jersey_number",
      "phone_number",
    ]
  end
end
