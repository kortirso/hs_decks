# Represents substitutions for checks
class Substitution < ApplicationRecord
  include Positionable

  belongs_to :check

  validates :check_id, presence: true
end
