class Line < ApplicationRecord

    NUMBER_OF_PARAMS = 5

    belongs_to :deck
    belongs_to :card

    validates :deck_id, :card_id, :max_amount, :priority, presence: true

    def self.build(params)
        deck = Deck.find_by(id: params[:deck_id])
        return false if deck.nil?
        params.each { |key, value| Line.check_position(key, value, deck.id) if key != 'deck_id' }
    end

    private

    def self.check_position(key, value, deck_id)
        position = value.to_h.to_a
        (1..(position.size / NUMBER_OF_PARAMS)).each do |index|
            card_name = position[NUMBER_OF_PARAMS * (index - 1)][1]
            Line.check_card(position, deck_id, card_name, index) unless card_name.empty?
        end
    end

    def self.check_card(position, deck_id, card_name, index)
        card = Card.return_by_name(card_name)
        priority = position[NUMBER_OF_PARAMS * (index - 1) + 1][1].to_i
        max_amount = position[NUMBER_OF_PARAMS * (index - 1) + 2][1].to_i
        min_mana = position[NUMBER_OF_PARAMS * (index - 1) + 3][1].to_i
        max_mana = position[NUMBER_OF_PARAMS * (index - 1) + 4][1].to_i
        if card && priority.is_a?(Integer) && max_amount.between?(1, 2) && min_mana.between?(0, 20) && max_mana.between?(0, 20)
            Line.create deck_id: deck_id, card_id: card.id, priority: priority, max_amount: max_amount, min_mana: min_mana, max_mana: max_mana
        end
    end
end
