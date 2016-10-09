class Check < ApplicationRecord
    include Positionable

    belongs_to :user
    belongs_to :deck

    has_one :substitution, dependent: :destroy

    validates :user_id, :deck_id, :success, presence: true

    scope :of_user, -> (user_id) { where user_id: user_id }

    def self.build(user_id, params, locale)
        user, checks = User.find(user_id), []
        user.checks.destroy_all
        Check.getting_decks(params).each do |deck|
            check = user.checks.create deck_id: deck.id, success: 0
            check = check.verify_deck(user.positions.collect_ids, deck.positions.collect_ids_with_rarity, params, locale)
            unless check.nil?
                checks.push check.success
                ActionCable.server.broadcast "user_#{check.user_id}_channel", check: check, deck: check.deck, order: checks.sort.reverse.index(check.success), username: check.deck.user.username, size: checks.size, button_1: I18n.t('buttons.view_check'), player: check.deck.player.locale_name(locale)
            end
        end
    end

    def verify_deck(cards, positions, params, locale)
        cards_ids, pos_ids, t = cards.collect { |i| i[0] }, positions.collect { |i| i[0] }, Time.current
        successed = self.calc_success(positions, pos_ids, cards, cards_ids, t, locale)
        subs = self.calc_subs(positions, pos_ids, cards, cards_ids, t)
        self.limitations(params, successed[0], successed[1], successed[2] + subs)
    end

    def calc_success(positions, pos_ids, cards, cards_ids, t, locale)
        result, dust, lines = 0, 0, []
        pos_ids.each do |pos|
            success, caption = 0, nil
            if cards_ids.include?(pos)
                if cards[cards_ids.index(pos)][1] >= positions[pos_ids.index(pos)][1]
                    result += positions[pos_ids.index(pos)][1]
                    success = 2
                else
                    result += 1
                    if positions[pos_ids.index(pos)][3]
                        add_dust = DustPrice.calc(positions[pos_ids.index(pos)][2])
                        dust += add_dust
                        caption = "#{I18n.t('check.caption_1')}#{add_dust}"
                    else
                        caption = "#{I18n.t('check.caption_2')}#{Card.find(positions[pos_ids.index(pos)][0]).collection.locale_name(locale)}"
                    end
                    success = 1
                end
            else
                if positions[pos_ids.index(pos)][3]
                    add_dust = DustPrice.calc(positions[pos_ids.index(pos)][2], positions[pos_ids.index(pos)][1])
                    dust += add_dust
                    caption = "#{I18n.t('check.caption_1')}#{add_dust}"
                else
                    caption = "#{I18n.t('check.caption_2')}#{Card.find(positions[pos_ids.index(pos)][0]).collection.locale_name(locale)}"
                end
            end
            lines.push "('#{pos}', #{self.id}, 'Check', '#{success}', '#{caption}', '#{t}', '#{t}')"
        end
        [result, dust, lines]
    end

    def calc_subs(positions, pos_ids, cards, cards_ids, t)
        substitution, lines, caption = Substitution.create(check_id: self.id), [], nil
        search_engine = SearchSubs.new(self.deck, positions)
        pos_ids.each do |pos|
            if cards_ids.include?(pos)
                search_engine.find_exchange(pos, 1) if cards[cards_ids.index(pos)][1] < positions[pos_ids.index(pos)][1]
            else
                search_engine.find_exchange(pos, positions[pos_ids.index(pos)][1])
            end
        end
        search_engine.cards_in_deck.each do |key, value|
            lines.push "('#{key}', #{substitution.id}, 'Substitution', '#{value}', '#{caption}', '#{t}', '#{t}')" unless value.nil?
        end
        lines
    end

    def limitations(params, success, dust, lines)
        if (params['success'].empty? || !params['success'].empty? && success >= params['success'].to_i) && (params['dust'].empty? || !params['dust'].empty? && dust <= params['dust'].to_i)
            self.update(success: success, dust: dust)
            Position.connection.execute "INSERT INTO positions (card_id, positionable_id, positionable_type, amount, caption, created_at, updated_at) VALUES #{lines.join(", ")}"
            return self
        else
            self.destroy
            return nil
        end
    end

    private

    def self.getting_decks(params)
        decks = Deck.all.includes(:positions)
        decks = decks.of_player_class(Player.return_en(params['playerClass'])) unless params['playerClass'].empty?
        decks = decks.of_format('standard') if params['formats'] == 'standard'
        decks
    end
end
