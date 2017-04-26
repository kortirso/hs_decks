module Subs
    class SearchSubsService
        attr_accessor :cards_in_deck
        attr_reader :cards

        def initialize(deck, cards_in_deck)
            @deck = deck
            @playerClass = deck.playerClass
            @cards = Card.for_all_classes.of_rarity('Free').or(Card.of_player_class(@playerClass).of_rarity('Free')).to_a
            @cards_in_deck = {}
            transform_cards_list(cards_in_deck)
        end

        def find_exchange(card_id, amount)
            return nil if (amount = check_must_have(card_id, amount)).zero? # 0. Check must_have field for position
            return nil if (amount = check_shifts_in_deck(card_id, amount)).zero? # 1. Looking for substitutions in decks shifts
            return nil if (amount = check_shifts_in_lines(card_id, amount)).zero? # 2. Looking for substitutions in decks lines
            return nil if (amount = check_shifts_in_class(amount)).zero? # 3. Looking for substitutions in other class decks
            return nil if (amount = check_all_shifts(card_id, amount)).zero? # 4. Looking for substitutions in all shifts
            check_random_shifts(card_id, amount) # 5. Looking last chance substitutions
        end

        private

        def transform_cards_list(param)
            param.each { |key, value| cards_in_deck[key] = value[:amount] }
        end

        def check_must_have(card_id, amount)
            pos = @deck.positions.find_by(card_id: card_id)
            amount = 0 if pos.must_have
            amount
        end

        def check_shifts_in_deck(card_id, amount)
            @deck.positions.find_by(card_id: card_id).exchanges.order(priority: :desc).each do |ex|
                return 0 if amount.zero?
                amount = check_cards_in_deck(card_id, ex.card_id, ex.max_amount, amount)
            end
            amount
        end

        def check_shifts_in_lines(card_id, amount)
            card = Card.find(card_id)
            @deck.lines.order(priority: :desc).each do |ex|
                return 0 if amount.zero?
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
                amount = check_cards_in_deck(card_id, ex.change_id, amount, amount) if is_sub_approached?(ex)
            end
            amount
        end

        def check_cards_in_deck(card_id, ex_card_id, ex_max_amount, amount)
            ex_card = Card.find(ex_card_id)
            if !cards_in_deck.key?(ex_card_id) || cards_in_deck[ex_card_id] == 1 && !ex_card.is_legendary? && !@deck.is_reno_type?
                amount = cards_replace(card_id, ex_card_id, ex_max_amount, amount)
            end
            amount
        end

        def cards_replace(card_id, ex_card_id, max_amount, amount)
            max_amount = 1 if @deck.is_reno_type?
            need_to_change = [max_amount, amount].min
            real_changes = [cards_in_deck[card_id], need_to_change].min
            cards_in_deck[card_id] -= real_changes
            cards_in_deck.delete(card_id) if cards_in_deck[card_id].zero?
            cards_in_deck[ex_card_id] = real_changes
            amount -= real_changes
        end

        def check_random_shifts(card_id, amount)
            card_cost = Card.find_by(id: card_id).cost
            cards_for_random = cards.select { |card| card_cost >= (card.cost - 1) && card_cost <= (card.cost + 1) && !cards_in_deck.key?(card.id.to_s) }
            if cards_for_random.size > 0
                cards_in_deck[card_id] -= amount
                cards_in_deck.delete(card_id) if cards_in_deck[card_id].zero?
                cards_in_deck[cards_for_random.sample.id.to_s] = amount
            end
        end

        def is_sub_approached?(shift)
            shift.change.playerClass.nil? || shift.change.playerClass == @playerClass
        end
    end
end