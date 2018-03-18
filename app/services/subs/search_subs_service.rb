module Subs
  # description
  class SearchSubsService
    attr_reader :deck, :race_cards, :user_collection, :random_cards, :cards_in_deck, :card

    def initialize(args)
      @deck = args[:deck]
      @user_collection = args[:user_collection]
      get_cards_in_deck(args[:deck_cards])
      get_cards_for_random
      get_race_cards
    end

    def find_exchange(card_id, amount)
      @card = Card.find(card_id)
      return nil if (amount = check_must_have(amount)).zero? # 0. Check must_have field for position
      return nil if (amount = check_shifts_in_deck(amount)).zero? # 1. Looking for substitutions in decks shifts
      return nil if (amount = check_shifts_in_lines(amount)).zero? # 2. Looking for substitutions in decks lines
      return nil if (amount = check_all_shifts(amount)).zero? # 3. Looking for substitutions in all shifts
      return nil if (amount = check_shifts_in_race(amount)).zero? # 4. Looking for substitutions in prefered race
      check_random_shifts(amount) # 5. Looking last chance substitutions
    end

    private

    def get_cards_in_deck(args)
      @cards_in_deck = {}
      args.each { |key, value| cards_in_deck[key] = value[:amount] }
    end

    def get_cards_for_random
      @random_cards = Card.for_all_classes.or(Card.of_player_class(deck.playerClass))
      @random_cards = random_cards.return_for_format('standard') if deck.formats == 'standard'
      @random_cards = random_cards.select { |c| user_collection[c.id.to_s].present? }
    end

    def get_race_cards
      @race_cards = deck.race.cards.select { |c| c.playerClass == 'Neutral' || c.playerClass == deck.playerClass }.select { |c| user_collection[c.id.to_s].present? } unless deck.race_id.nil?
    end

    def check_must_have(amount)
      pos = deck.positions.find_by(card_id: card.id)
      amount = 0 if pos.must_have
      amount
    end

    def check_shifts_in_deck(amount)
      deck.positions.find_by(card_id: card.id).exchanges.order(priority: :desc).select { |ex| user_collection[ex.card_id.to_s].present? }.each do |ex|
        amount = check_cards_in_deck(ex.card_id, ex.max_amount, amount)
        return 0 if amount.zero?
      end
      amount
    end

    def check_shifts_in_lines(amount)
      deck.lines.order(priority: :desc).select { |ex| user_collection[ex.card_id.to_s].present? }.each do |ex|
        if card.cost.between?(ex.min_mana, ex.max_mana)
          amount = check_cards_in_deck(ex.card_id, ex.max_amount, amount)
        end
        return 0 if amount.zero?
      end
      amount
    end

    def check_all_shifts(amount)
      card.shifts.includes(:card, :change).order(priority: :desc).select { |ex| user_collection[ex.change_id.to_s].present? }.each do |ex|
        amount = check_cards_in_deck(ex.change_id, amount, amount) if is_sub_approached?(ex)
        return 0 if amount.zero?
      end
      amount
    end

    def check_shifts_in_race(amount)
      return amount if deck.race_id.nil?
      race_cards.each do |ex|
        amount = check_cards_in_deck(ex.id, user_collection[ex.id.to_s], amount)
        return 0 if amount.zero?
      end
      amount
    end

    def check_cards_in_deck(ex_card_id, ex_max_amount, amount)
      ex_card = Card.find(ex_card_id)
      if !cards_in_deck.key?(ex_card_id) || cards_in_deck[ex_card_id] == 1 && !ex_card.legendary? && !deck.reno_type?
        amount = cards_replace(ex_card_id, ex_max_amount, amount)
      end
      amount
    end

    def cards_replace(ex_card_id, ex_max_amount, amount)
      ex_max_amount = 1 if deck.reno_type?
      ex_in_collection = user_collection[ex_card_id.to_s].nil? ? 0 : user_collection[ex_card_id.to_s]
      real_changes = [cards_in_deck[card.id.to_s], ex_max_amount, amount, ex_in_collection].min

      if real_changes > 0
        cards_in_deck[card.id.to_s] -= real_changes
        cards_in_deck.delete(card.id.to_s) if cards_in_deck[card.id.to_s].zero?
        cards_in_deck[ex_card_id] = 0 if cards_in_deck[ex_card_id].nil?
        cards_in_deck[ex_card_id] += real_changes
      end

      amount - real_changes
    end

    def check_random_shifts(amount)
      cards_for_random = random_cards.select { |for_random| card.cost.between?(for_random.cost - 1, for_random.cost + 2) && cards_in_deck[for_random.id.to_s].nil? }

      %w[Legendary Epic Rare Common Free].each do |rarity|
        cards_for_random.select { |c| c.rarity == rarity }.each do |ex|
          break if amount <= 0
          real_changes = [user_collection[ex.id.to_s], amount].min
          cards_in_deck[card.id.to_s] -= real_changes
          cards_in_deck.delete(card.id.to_s) if cards_in_deck[card.id.to_s].zero?
          cards_in_deck[ex.id.to_s] = real_changes
          amount -= real_changes
        end
      end
    end

    def is_sub_approached?(shift)
      shift.change.playerClass.nil? || shift.change.playerClass == deck.playerClass
    end
  end
end
