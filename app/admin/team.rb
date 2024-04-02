ActiveAdmin.register Team do
  permit_params :name
end

class Team < ApplicationRecord
  def display_name
    name
  end
end
