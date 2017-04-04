class SearchEngine
    attr_reader :user, :user_collection, :deck_cards, :check_params, :check

    def initialize(args)
        @user = args[:user]
        @user_collection = user.positions.collect_ids_as_hash
        @deck_cards = nil
        @check_params = args[:params].to_h
        @check = nil
    end

    def build(checks = [])
        user.checks.destroy_all
        getting_decks.each do |deck|
            @check = user.checks.create deck_id: deck.id, success: 0
            @deck_cards = deck.positions.collect_ids_with_rarity_as_hash
            if verify_deck
                checks.push check.success
                ActionCable.server.broadcast "user_#{check.user_id}_channel", check: check, deck: check.deck, order: checks.sort.reverse.index(check.success), username: check.deck.user.username, size: checks.size, button_1: I18n.t('buttons.view_check'), player: check.deck.player.locale_name(I18n.locale)
            end
        end
    end

    private

    def getting_decks
        decks = Deck.all.includes(:positions)
        decks = decks.of_player_class(Player.return_en(check_params[:playerClass])) unless check_params[:playerClass].empty?
        decks = decks.of_format('standard') if check_params[:formats] == 'standard'
        decks = decks.of_power(check_params[:power]) if check_params[:power].to_i.between?(1, 10)
        decks = decks.of_style(check_params[:style]) unless check_params[:style].empty?
        decks
    end

    def verify_deck
        successed = calc_success
        successed[:lines] += calc_subs
        limitations(successed)
    end

    def calc_success
        result, dust, lines, t = 0, 0, [], Time.current
        deck_cards.each_key do |deck_card|
            success, caption = 0, nil
            if user_collection.key?(deck_card)
                success = user_collection[deck_card] >= deck_cards[deck_card][:amount] ? 2 : 1
                result += deck_cards[deck_card][:amount] - (2 - success)
            end
            if success < 2
                checker = check_crafted(deck_card)
                dust += checker[:dust]
                caption = checker[:caption]
            end
            lines.push "('#{deck_card.to_i}', #{check.id}, 'Check', '#{success}', '#{caption}', '#{t}', '#{t}')"
        end
        {result: result, dust: dust, lines: lines}
    end

    def check_crafted(deck_card, add_dust = 0)
        if deck_cards[deck_card][:crafted]
            add_dust = DustPrice.calc(deck_cards[deck_card][:rarity], deck_cards[deck_card][:amount])
            caption = "#{I18n.t('pages.check.main.caption_1')} - #{add_dust}"
        else
            caption = "#{I18n.t('pages.check.main.caption_2')} - #{Card.find(deck_card).collection.locale_name(I18n.locale)}"
        end
        {dust: add_dust, caption: caption}
    end

    def calc_subs
        substitution, lines, caption, t = Substitution.create(check_id: check.id), [], nil, Time.current
        search_engine = SearchSubs.new(check.deck, deck_cards)
        deck_cards.each_key do |deck_card|
            if user_collection.key?(deck_card)
                search_engine.find_exchange(deck_card, 1) if user_collection[deck_card] < deck_cards[deck_card][:amount]
            else
                search_engine.find_exchange(deck_card, deck_cards[deck_card][:amount])
            end
        end
        search_engine.cards_in_deck.each { |key, value| lines.push "('#{key}', #{substitution.id}, 'Substitution', '#{value}', '#{caption}', '#{t}', '#{t}')" unless value.nil? }
        lines
    end

    def limitations(args)
        if (check_params[:success].empty? || args[:result] >= check_params[:success].to_i) && (check_params[:dust].empty? || args[:dust] <= check_params[:dust].to_i)
            check.update(success: args[:result], dust: args[:dust])
            Position.connection.execute "INSERT INTO positions (card_id, positionable_id, positionable_type, amount, caption, created_at, updated_at) VALUES #{args[:lines].join(", ")}"
            return true
        else
            check.destroy
            return false
        end
    end
end