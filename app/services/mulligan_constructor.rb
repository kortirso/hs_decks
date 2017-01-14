class MulliganConstructor
    attr_reader :mulligans, :mulligan

    def initialize(params)
        @mulligans = params.to_h
        @mulligan = nil
    end

    def build
        mulligans.each { |key, value| check_mulligan(key, value) }
    end

    private

    def check_mulligan(key, cards)
        @mulligan = Mulligan.find_by(id: key.to_i)
        return false if mulligan.nil?
        cards.values.each { |card_name| check_card(card_name) if !card_name.empty? && mulligan.positions.count < 6 }
    end

    def check_card(card_name)
        card = Card.return_by_name(card_name)
        return false unless card
        mulligan.positions.create card_id: card.id, amount: 1 if !mulligan.cards.include?(card)
    end
end