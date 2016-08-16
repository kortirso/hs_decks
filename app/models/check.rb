class Check < ApplicationRecord
    include Positionable

    belongs_to :user
    belongs_to :deck

    validates :user_id, :deck_id, :success, presence: true

    scope :of_user, -> (user_id) { where user_id: user_id }

    def self.build(user_id, params)
        params, user, checks = Check.getting_params(params), User.find(user_id), []
        user.checks.destroy_all
        cards_ids = user.positions.collect_ids
        Check.getting_decks(params).each do |deck|
            check = Check.check_deck(cards_ids, deck.positions.collect_ids_with_rarity, user_id, deck.id)
            checks = check.limitations(checks, params)
        end
    end

    def limitations(checks, params)
        if (params['success'].empty? || !params['success'].empty? && self.success >= params['success'].to_i) && (params['dust'].empty? || !params['dust'].empty? && self.dust <= params['dust'].to_i)
            checks.push self.success
            ActionCable.server.broadcast "user_#{self.user_id}_channel", check: self, deck: self.deck, order: checks.sort.reverse.index(self.success), username: self.deck.user.email, size: checks.size
        else
            self.destroy
        end
        return checks
    end

    private

    def self.getting_params(params)
        return params.permit(:success, :dust, :playerClass, :formats).to_h
    end

    def self.getting_decks(params)
        decks = Deck.all.includes(:positions)
        decks = decks.of_player_class(params['playerClass']) unless params['playerClass'].empty?
        decks = decks.of_format('standard') if params['formats'] == 'standard'
        decks
    end

    def self.check_deck(cards, positions, user_id, deck_id)
        result, dust, cards_ids, pos_ids, lines, t = 0, 0, cards.collect { |i| i[0] }, positions.collect { |i| i[0] }, [], Time.current
        check = Check.create deck_id: deck_id, user_id: user_id, success: 0
        pos_ids.each do |pos|
            if cards_ids.include?(pos)
                if cards[cards_ids.index(pos)][1] >= positions[pos_ids.index(pos)][1]
                    result += positions[pos_ids.index(pos)][1]
                    success = 2
                else
                    result += 1
                    dust += DustPrice.calc(positions[pos_ids.index(pos)][2])
                    success = 1
                end
            else
                success = 0
                dust += DustPrice.calc(positions[pos_ids.index(pos)][2], positions[pos_ids.index(pos)][1])
            end
            lines.push "('#{pos}', #{check.id}, 'Check', '#{success}', '#{t}', '#{t}')"
        end
        check.update(success: (result * 100) / 30, dust: dust)
        Position.connection.execute "INSERT INTO positions (card_id, positionable_id, positionable_type, amount, created_at, updated_at) VALUES #{lines.join(", ")}"
        check
    end
end
