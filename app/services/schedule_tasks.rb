class ScheduleTasks
    def execute
        check_cards_format
        check_cards_crafted
        check_decks_format
        calc_cards_usability
    end

    private

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