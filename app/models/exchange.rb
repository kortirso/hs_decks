class Exchange < ApplicationRecord

    NUMBER_OF_PARAMS = 3

    belongs_to :position
    belongs_to :card

    validates :position_id, :card_id, presence: true

    def self.build(params)
        deck = Deck.find_by(id: params[:deck_id])
        return false if deck.nil?
        params.each { |key, value| Exchange.check_position(key, value) if key != 'deck_id' }
    end

    private

    def self.check_position(key, value)
        position = value.to_h.to_a
        (1..(position.size / NUMBER_OF_PARAMS)).each do |index|
            card_name = position[NUMBER_OF_PARAMS * (index - 1)][1]
            Exchange.check_card(position, Position.find(key.to_i).id, card_name, index) unless card_name.empty?
        end
    end

    def self.check_card(position, position_id, card_name, index)
        card = Card.return_by_name(card_name)
        priority = position[NUMBER_OF_PARAMS * (index - 1) + 1][1].to_i
        max_amount = card.is_legendary? ? 1 : position[NUMBER_OF_PARAMS * (index - 1) + 2][1].to_i
        if card && Exchange.check_parameters(priority, max_amount)
            Exchange.creation(priority, max_amount, position_id, card.id)
        end
    end

    def self.creation(priority, max_amount, position_id, card_id)
        exchange = Exchange.find_by(position_id: position_id, card_id: card_id)
        if exchange
            exchange.update priority: priority, max_amount: max_amount
        else
            Exchange.create position_id: position_id, card_id: card_id, priority: priority, max_amount: max_amount
        end
    end

    def self.check_parameters(priority, max_amount)
        return true if priority.is_a?(Integer) && max_amount.between?(1, 2)
        false
    end
end
