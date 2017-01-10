class ShiftsCreationEngine
    
    NUMBER_OF_PARAMS = 2

    attr_reader :cards_params, :card_for_shift

    def initialize(params)
        p = params.to_h
        @card_for_shift = Card.return_by_name(p[:main_card])
        @cards_params = p[:shifts].to_a
    end

    def build
        return false unless card_for_shift
        (1..(cards_params.size / NUMBER_OF_PARAMS)).each do |index|
            card_name = cards_params[NUMBER_OF_PARAMS * (index - 1)][1]
            check_card(card_name, index) unless card_name.empty?
        end
    end

    private

    def check_card(card_name, index)
        card = Card.return_by_name(card_name)
        return false unless card
        priority = cards_params[NUMBER_OF_PARAMS * (index - 1) + 1][1].to_i
        creation(priority, card.id) if check_parameters(priority)
    end

    def check_parameters(priority)
        priority.is_a?(Integer)
    end

    def creation(priority, card_id)
        shift = Shift.find_by(card_id: card_for_shift.id, change_id: card_id)
        return shift.update(priority: priority) if shift
        Shift.create card_id: card_for_shift.id, change_id: card_id, priority: priority
    end
end