class Player < ApplicationRecord
  has_many :team_players, dependent: :destroy
  has_many :teams, through: :team_players

  validates :phone_number, presence: true, uniqueness: true
  validates :api_token, presence: true, uniqueness: true
end
