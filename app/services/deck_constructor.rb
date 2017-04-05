class DeckConstructor
    attr_reader :deck_params, :cards_params, :user_id, :deck

    def initialize(params, user_id, deck = nil)
        @deck_params = params[:deck].to_h
        @cards_params = params[:cards_list].to_h
        @user_id = user_id
        @deck = deck
    end

    def build
        return false unless good_params?
        @deck = Deck.create name: deck_params[:name], name_en: deck_params[:name_en], playerClass: deck_params[:playerClass], formats: deck_params[:formats], link: deck_params[:link], caption: deck_params[:caption], caption_en: deck_params[:caption_en], author: deck_params[:author], user_id: user_id, player_id: Player.find_by(name_en: deck_params[:playerClass]).id, power: deck_params[:power], style_id: Style.return_id_by_name(deck_params[:style]), reno_type: deck_params[:reno_type] == '1' ? false : true
        build_positions
        update_deck
        true
    end

    def refresh
        return false unless good_params?
        deck.update name: deck_params[:name], name_en: deck_params[:name_en], link: deck_params[:link], caption: deck_params[:caption], caption_en: deck_params[:caption_en], author: deck_params[:author], power: deck_params[:power], style_id: Style.return_id_by_name(deck_params[:style])
        update_positions
        update_deck
        true
    end

    private

    def good_params?
        return false if check_deck_params
        return false if check_30_cards
        return false if check_cards_dublicates
        return false if check_cards_class
        ## todo: check card format
        ## todo: check 1 legendary
        return true
    end

    def check_deck_params
        deck_params[:name].empty?
    end

    def check_30_cards
        amount = 0
        cards_params.each_value { |value| amount += value.to_i }
        amount != 30
    end

    def check_cards_dublicates
        ids = cards_params.keys
        ids.size != ids.uniq.size
    end

    def check_cards_class
        ids = cards_params.keys.map { |k| k.to_i }
        allowed_cards_ids = Card.for_all_classes.or(Card.not_heroes.of_player_class(deck.try(:playerClass) || deck_params[:playerClass])).collect { |x| x.id }
        errors = 0
        ids.each { |pos| errors += 1 unless allowed_cards_ids.include? pos }
        errors != 0
    end

    def build_positions
        positions, t = [], Time.current
        cards_params.each { |key, value| positions.push "(#{key.to_i}, '#{deck.id}', 'Deck', '#{value.to_i}', '#{t}', '#{t}')" if value.to_i > 0 }
        Position.connection.execute "INSERT INTO positions (card_id, positionable_id, positionable_type, amount, created_at, updated_at) VALUES #{positions.join(", ")}"
    end

    def update_positions
        cards_ids = cards_params.keys.map { |value| value.to_i }
        old_ids = deck.positions.collect_ids.collect { |pos| pos[0] }
        old_ids.each do |pos|
            position = deck.positions.find_by(card_id: pos)
            amount = cards_params[pos.to_s].to_i
            if cards_ids.include?(pos) && amount > 0
                position.update(amount: amount)
            else
                position.destroy
            end
        end
        cards_ids.each { |pos| deck.positions.create card_id: pos, amount: cards_params[pos.to_s].to_i if !old_ids.include?(pos) && cards_params[pos.to_s].to_i > 0 }
    end

    def update_deck
        calc_price
        deck.check_deck_format
    end

    def calc_price
        price = 0
        deck.positions.includes(:card).each { |pos| price += DustPrice.calc(pos.card.rarity, pos.amount) }
        deck.update(price: price)
    end
end