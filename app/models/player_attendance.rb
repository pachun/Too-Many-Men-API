class PlayerAttendance < ApplicationRecord
  belongs_to :game
  belongs_to :player

  validates :player, uniqueness: { scope: :game }
end
