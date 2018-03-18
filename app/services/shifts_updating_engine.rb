# shifts updating engine
class ShiftsUpdatingEngine
  NUMBER_OF_PARAMS = 2

  attr_reader :cards_params, :card_for_shift, :shifts

  def initialize(params)
    @cards_params = params.to_h
    @card_for_shift = nil
    @shifts = nil
  end

  def build
    cards_params.each { |key, value| check_position(key, value) }
  end

  private def check_position(key, value)
    @card_for_shift = Card.find_by(id: key.to_i)
    return false unless card_for_shift
    @shifts = value.to_a
    (1..(shifts.size / NUMBER_OF_PARAMS)).each do |index|
      card_name = shifts[NUMBER_OF_PARAMS * (index - 1)][1]
      check_card(card_name, index) unless card_name.empty?
    end
  end

  private def check_card(card_name, index)
    card = Card.return_by_name(card_name)
    return false unless card
    priority = shifts[NUMBER_OF_PARAMS * (index - 1) + 1][1].to_i
    creation(priority, card.id) if check_parameters(priority)
  end

  private def check_parameters(priority)
    priority.is_a?(Integer)
  end

  private def creation(priority, card_id)
    shift = Shift.find_by(card_id: card_for_shift.id, change_id: card_id)
    return shift.update(priority: priority) if shift
    Shift.create card_id: card_for_shift.id, change_id: card_id, priority: priority
  end
end
