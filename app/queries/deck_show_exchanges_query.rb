# Returns positions for decks
class DeckShowExchangesQuery
  attr_reader :deck

  def initialize(deck)
    @deck = deck
  end

  def query
    deck.positions.includes(:card, :exchanges).to_a.sort_by { |elem| [elem.card.cost, elem.card["name_#{I18n.locale}"]] }
  end
end
