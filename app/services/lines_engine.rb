class LinesEngine

    NUMBER_OF_PARAMS = 5

    attr_reader :cards_params, :exchanges, :deck

    def initialize(params)
        p = params.to_h
        @deck = Deck.find_by(id: p[:deck_id])
        p.delete(:deck_id)
        @cards_params = p
        @exchanges = nil
    end

    def build
        return false if deck.nil?
        cards_params.each_value { |value| check_position(value) }
    end

    private

    def check_position(value)
        @exchanges = value.to_a
        (1..(exchanges.size / NUMBER_OF_PARAMS)).each do |index|
            card_name = exchanges[NUMBER_OF_PARAMS * (index - 1)][1]
            check_card(card_name, index) unless card_name.empty?
        end
    end

    def check_card(card_name, index)
        card = Card.return_by_name(card_name)
        return false unless card
        priority = exchanges[NUMBER_OF_PARAMS * (index - 1) + 1][1].to_i
        max_amount = card.legendary? ? 1 : exchanges[NUMBER_OF_PARAMS * (index - 1) + 2][1].to_i
        min_mana = exchanges[NUMBER_OF_PARAMS * (index - 1) + 3][1].to_i
        max_mana = exchanges[NUMBER_OF_PARAMS * (index - 1) + 4][1].to_i
        creation(priority, max_amount, min_mana, max_mana, card.id) if check_parameters(priority, max_amount, min_mana, max_mana)
    end

    def check_parameters(priority, max_amount, min_mana, max_mana)
        priority.is_a?(Integer) && max_amount.is_a?(Integer) && max_amount.between?(1, 2) && min_mana.is_a?(Integer) && min_mana.between?(0, 20) && max_mana.is_a?(Integer) && max_mana.between?(0, 20)
    end

    def creation(priority, max_amount, min_mana, max_mana, card_id)
        line = deck.lines.find_by(card_id: card_id)
        return line.update(priority: priority, max_amount: max_amount, min_mana: min_mana, max_mana: max_mana) if line
        deck.lines.create card_id: card_id, priority: priority, max_amount: max_amount, min_mana: min_mana, max_mana: max_mana
    end
end