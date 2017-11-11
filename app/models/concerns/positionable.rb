# Represents deck like objects
module Positionable
    extend ActiveSupport::Concern

    included do
        has_many :positions, as: :positionable, dependent: :destroy
        has_many :cards, through: :positions
    end
end
