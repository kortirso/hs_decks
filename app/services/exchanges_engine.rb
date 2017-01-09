class ExchangesEngine
    
    NUMBER_OF_PARAMS = 3

    attr_reader :cards_params, :deck_id, :exchanges, :position

    def initialize(params)
        p = params.to_h
        @deck_id = p[:deck_id]
        p.delete(:deck_id)
        @cards_params = p
        @exchanges = nil
        @position = nil
    end

    def build
        deck = Deck.find_by(id: deck_id)
        return false if deck.nil?
        cards_params.each { |key, value| check_position(key, value) }
    end

    private

    def check_position(key, value)
        @exchanges = value.to_a
        @position = Position.find_by(id: key.to_i)
        return false if position.nil?
        (1..((exchanges.size - 1) / NUMBER_OF_PARAMS)).each do |index|
            card_name = exchanges[NUMBER_OF_PARAMS * (index - 1) + 1][1]
            check_card(card_name, index) unless card_name.empty?
        end
        position.set_musthave(exchanges[0][1] == '1' ? true : false)
    end

    def check_card(card_name, index)
        card = Card.return_by_name(card_name)
        priority = exchanges[NUMBER_OF_PARAMS * (index - 1) + 2][1].to_i
        max_amount = card.is_legendary? ? 1 : exchanges[NUMBER_OF_PARAMS * (index - 1) + 3][1].to_i
        creation(priority, max_amount, card.id) if card && check_parameters(priority, max_amount)
    end

    def check_parameters(priority, max_amount)
        priority.is_a?(Integer) && max_amount.is_a?(Integer) && max_amount.between?(1, 2)
    end

    def creation(priority, max_amount, card_id)
        exchange = position.exchanges.find_by(card_id: card_id)
        if exchange
            exchange.update priority: priority, max_amount: max_amount
        else
            position.exchanges.create card_id: card_id, priority: priority, max_amount: max_amount
        end
    end
end