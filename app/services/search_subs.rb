class SearchSubs

    attr_accessor :cards_in_deck
    attr_reader :cards

    def initialize(deck, cards_in_deck)
        @deck = deck
        @playerClass = deck.playerClass
        @cards = Card.for_all_classes.of_rarity('Free').or(Card.not_heroes.of_player_class(@playerClass).of_rarity('Free')).to_a
        @cards_in_deck = transform_cards_list(cards_in_deck)
    end

    def find_exchange(card_id, amount)
        return nil if (amount = check_shifts_in_deck(card_id, amount)).zero? # 1. todo: Looking for substitutions in decks shifts
        return nil if (amount = check_shifts_in_lines(card_id, amount)).zero? # 2. todo: Looking for substitutions in decks lines
        return nil if (amount = check_shifts_in_class(amount)).zero? # 3. todo: Looking for substitutions in other class decks
        return nil if (amount = check_all_shifts(card_id, amount)).zero? # 4. Looking for substitutions in all shifts
        check_random_shifts(card_id, amount) # 5. Looking last chance substitutions
    end

    private

    def transform_cards_list(cards_list)
        result = {}
        cards_list.each { |pos| result[pos[0]] = pos[1] }
        result
    end

    def check_shifts_in_deck(card_id, amount)
        @deck.positions.find_by(card_id: card_id).exchanges.includes(:card).order(priority: :desc).each do |ex|
            return 0 if amount.zero?
            amount = check_cards_in_deck(card_id, ex.card_id, ex.max_amount, amount)
        end
        amount
    end

    def check_shifts_in_lines(card_id, amount)
        @deck.lines.includes(:card).order(priority: :desc).each do |ex|
            return 0 if amount.zero?
            card = Card.find(card_id)
            if ex.min_mana <= card.cost && ex.max_mana >= card.cost
                amount = check_cards_in_deck(card_id, ex.card_id, ex.max_amount, amount)
            end
        end
        amount
    end

    def check_shifts_in_class(amount)
        amount
    end

    def check_all_shifts(card_id, amount)
        card_for_sub = Card.find_by(id: card_id)
        card_for_sub.shifts.includes(:card, :change).order(priority: :desc).each do |ex|
            return 0 if amount.zero?
            amount = check_cards_in_deck(card_id, ex.card_id, ex.max_amount, amount) if is_sub_approached?(ex)
        end
        amount
    end

    def check_cards_in_deck(card_id, ex_card_id, ex_max_amount, amount)
        ex_card = Card.find(ex_card_id)
        if !cards_in_deck.key?(ex_card_id)
            amount = cards_replace(card_id, ex_card_id, ex_max_amount, amount)
        elsif cards_in_deck.key?(ex_card_id) && cards_in_deck[ex_card_id] == 1 && !ex_card.is_legendary?
            amount = cards_reshuffle(card_id, ex_card_id, amount)
        end
        amount
    end

    def cards_replace(card_id, ex_card_id, max_amount, amount)
        need_to_change = [max_amount, amount].min
        cards_in_deck[card_id] = need_to_change == cards_in_deck[card_id] ? nil : 1
        cards_in_deck[ex_card_id] = need_to_change
        amount -= need_to_change
    end

    def cards_reshuffle(card_id, ex_card_id, amount)
        amount -= 1
        cards_in_deck[card_id] = amount == 0 ? nil : 1
        cards_in_deck[ex_card_id] = 2
        amount
    end

    def check_random_shifts(card_id, amount)
        card_for_sub = Card.find_by(id: card_id)
        cards_for_random = cards.select { |card| card.cost == card_for_sub.cost }.delete_if { |card| is_card_in_deck?(card.id, card_id) }
        if cards_for_random.size > 0
            cards_in_deck[card_id] = nil
            cards_in_deck[cards_for_random.sample.id] = amount
        end
    end

    def is_sub_approached?(shift)
        return false unless shift.change.playerClass.nil? || shift.change.playerClass == @playerClass
        true
    end

    def is_card_in_deck?(ex_card_id, card_id)
        return true unless cards_in_deck[ex_card_id].nil?
        return true if ex_card_id == card_id
        false
    end
end