every :day, at: '1am' do
    runner "Collection.add_new_collection"
    runner "Card.check_locale('en')"
    runner "Card.check_locale('ru')"
    runner "Card.check_cards_format"
    runner "Deck.check_format"
end
