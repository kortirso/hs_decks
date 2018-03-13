# Represents App Versions
class About < ApplicationRecord
  include Localizeable

  has_many :fixes, dependent: :destroy

  validates :version, :name, presence: true
end
