class ScheduleTasks
    def execute
        add_new_collection
        ['en', 'ru'].each { |locale| check_cards_locale(locale) }
        check_cards_format
        check_cards_crafted
        check_decks_format
        calc_cards_usability
    end

    private

    def add_new_collection
        Collection.includes(:cards).select { |c| c.cards.size == 0 }.each { |collection| add_new_cards(collection) }
    end

    def add_new_cards(collection)
        Message.new.get_request[collection.name_en].each do |card|
            collection.cards.create cardId: card['cardId'], name_en: card['name'], type: card['type'], cost: card['cost'], playerClass: card['playerClass'], rarity: card['rarity'], image_en: card['img']
        end
    end

    def check_cards_locale(locale)
        result = Message.new(locale).get_request
        Collection.includes(:cards).each do |collection|
            result[collection.name_en].each do |row|
                card = collection.cards.find_by(cardId: row['cardId'])
                refresh_params(card, locale, row) if card
            end
        end
    end

    def refresh_params(card, locale, row)
        card["name_#{locale}"] = row['name']
        card["image_#{locale}"] = row['img']
        %w(type cost playerClass multiClassGroup rarity).each { |param| card[param] = row[param] }
        card.player_id = Player.find_by(name_en: row['playerClass']).id unless row['playerClass'].nil?
        card.multi_class_id = MultiClass.find_by(name_en: row['multiClassGroup']).id unless row['multiClassGroup'].nil?
        card.save if card.changed?
    end

    def check_cards_format
        Collection.of_format('wild').includes(:cards).each { |collection| collection.cards.update_all(formats: 'wild') unless collection.cards.last.wild_format? }
    end

    def check_cards_crafted
        Collection.adventures.includes(:cards).each { |collection| collection.cards.update_all(craft: false) if collection.cards.last.is_crafted? }
    end

    def check_decks_format
        Deck.includes(:cards).each { |deck| deck.check_deck_format }
    end

    def calc_cards_usability
        Card.all.update_all(usable: 0)
        Deck.includes(:cards).each do |deck|
            deck.cards.each do |card|
                updated_card = Card.find(card.id)
                updated_card.update(usable: updated_card.usable + 1)
            end
        end
        Exchange.all.each do |ex|
            updated_card = Card.find(ex.card_id)
            updated_card.update(usable: updated_card.usable + 1)
        end
        Line.all.each do |line|
            updated_card = Card.find(line.card_id)
            updated_card.update(usable: updated_card.usable + 1)
        end
        Shift.all.each do |shift|
            updated_card = Card.find(shift.change_id)
            updated_card.update(usable: updated_card.usable + 1)
        end
    end
end