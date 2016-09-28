class SearchSubs

    def initialize(playerClass)
        @playerClass = playerClass
        @cards = Card.for_all_classes.of_rarity('Free').or(Card.not_heroes.of_player_class(playerClass).of_rarity('Free')).to_a
    end

    def find_exchange(card_id, amount, pos_ids, subs_ids)
        return result unless (result = check_shifts_in_deck).nil? # 1. todo: Looking for substitutions in decks shifts
        return result unless (result = check_shifts_in_class).nil? # 2. todo: Looking for substitutions in other class decks
        return result unless (result = check_all_shifts(card_id, pos_ids, subs_ids, amount)).nil? # 3. Looking for substitutions in all shifts
        check_random_shifts(card_id, pos_ids, subs_ids, amount) # 4. Looking last chance substitutions
    end

    private

    def check_shifts_in_deck
        nil
    end

    def check_shifts_in_class
        nil
    end

    def check_all_shifts(card_id, pos_ids, subs_ids, amount)
        card_for_sub = Card.find_by(id: card_id)
        card_for_sub.shifts.order(priority: :desc).each do |shift|
            return [shift.change.id, amount] if is_sub_approached?(shift, pos_ids, subs_ids)
        end
        nil
    end

    def check_random_shifts(card_id, pos_ids, subs_ids, amount)
        card_for_sub = Card.find_by(id: card_id)
        cards_for_random = @cards.select { |card| card.cost == card_for_sub.cost }.delete_if { |card| is_card_in_deck?(card, pos_ids, subs_ids, card_id) }
        cards_for_random.size > 0 ? [cards_for_random.sample.id, amount] : [card_id, amount]
    end

    def is_sub_approached?(shift, pos_ids, subs_ids)
        return false unless shift.change.playerClass.nil? || shift.change.playerClass == @playerClass
        return false if pos_ids.include? shift.change.id
        return false if subs_ids.include? shift.change.id
        true
    end

    def is_card_in_deck?(card, pos_ids, subs_ids, card_id)
        return true if pos_ids.include?(card.id)
        return true if subs_ids.include?(card.id)
        return true if card.id == card_id
        false
    end
end