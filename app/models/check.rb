class Check < ApplicationRecord
    belongs_to :user
    belongs_to :deck

    validates :user_id, :deck_id, :success, presence: true

    scope :of_user, -> (user_id) { where user_id: user_id }

    def self.build(user_id, params)
        params, user, checks = Check.getting_params(params), User.find(user_id), []
        user.checks.destroy_all
        cards_ids = user.packs.collect_ids
        Check.getting_decks(params).each do |deck|
            rating = Check.check_deck(cards_ids, deck.positions.collect_ids)
            if params['success'].empty? || !params['success'].empty? && rating >= params['success'].to_i
                check = Check.create deck_id: deck.id, success: rating, user_id: user_id
                checks.push check.success
                sortable_checks = checks.sort.reverse
                ActionCable.server.broadcast "user_#{check.user_id}_channel", check: check, deck: check.deck, order: sortable_checks.index(check.success) + 1, username: check.deck.user.email, size: checks.size
            end
        end
    end

    private

    def self.getting_params(params)
        return params.permit(:success, :playerClass, :formats).to_h
    end

    def self.getting_decks(params)
        decks = Deck.all.includes(:positions)
        decks = decks.of_player_class(params['playerClass']) unless params['playerClass'].empty?
        decks = decks.of_format('standard') if params['formats'] == 'standard'
        decks
    end

    def self.check_deck(cards, positions)
        result, cards_ids, pos_ids = 0, cards.collect { |i| i[0] }, positions.collect { |i| i[0] }
        pos_ids.each do |pos|
            if cards_ids.include?(pos)
                cards[cards_ids.index(pos)][1] >= positions[pos_ids.index(pos)][1] ? result += positions[pos_ids.index(pos)][1] : result += 1
            end
        end
        (result * 100) / 30
    end
end
