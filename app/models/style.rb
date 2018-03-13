# Represents decks styles
class Style < ApplicationRecord
  include Localizeable
  extend Nameable

  has_many :decks

  validates :name, presence: true

  class << self
    def names_list(locale)
      all.collect { |style| style.name[locale] }.sort
    end
  end
end
