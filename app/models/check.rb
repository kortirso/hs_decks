class Check < ApplicationRecord
    include Positionable

    belongs_to :user
    belongs_to :deck

    validates :user_id, :deck_id, :success, presence: true

    scope :of_user, -> (user_id) { where user_id: user_id }

    def self.build(user_id, params)
        params, user, checks = Check.getting_params(params), User.find(user_id), []
        user.checks.destroy_all
        Check.getting_decks(params).each do |deck|
            check = user.checks.create deck_id: deck.id, success: 0
            check = check.verify_deck(user.positions.collect_ids, deck.positions.collect_ids_with_rarity, params)
            unless check.nil?
                checks.push check.success
                ActionCable.server.broadcast "user_#{check.user_id}_channel", check: check, deck: check.deck, order: checks.sort.reverse.index(check.success), username: check.deck.user.email, size: checks.size
            end
        end
    end

    def verify_deck(cards, positions, params)
        dust, cards_ids, pos_ids, lines, t = 0, cards.collect { |i| i[0] }, positions.collect { |i| i[0] }, [], Time.current
        pos_ids.each do |pos|
            if cards_ids.include?(pos)
                if cards[cards_ids.index(pos)][1] >= positions[pos_ids.index(pos)][1]
                    success = 2
                else
                    dust += DustPrice.calc(positions[pos_ids.index(pos)][2])
                    success = 1
                end
            else
                success = 0
                dust += DustPrice.calc(positions[pos_ids.index(pos)][2], positions[pos_ids.index(pos)][1])
            end
            lines.push "('#{pos}', #{self.id}, 'Check', '#{success}', '#{t}', '#{t}')"
        end
        return self.limitations(params, dust, lines)
    end

    def limitations(params, dust, lines)
        deck_price = self.deck.price
        success = (deck_price - dust) * 100 / deck_price
        if (params['success'].empty? || !params['success'].empty? && success >= params['success'].to_i) && (params['dust'].empty? || !params['dust'].empty? && dust <= params['dust'].to_i)
            self.update(success: success, dust: dust)
            Position.connection.execute "INSERT INTO positions (card_id, positionable_id, positionable_type, amount, created_at, updated_at) VALUES #{lines.join(", ")}"
            return self
        else
            self.destroy
            return nil
        end
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
end
