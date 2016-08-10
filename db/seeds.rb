collections = []
result = Message.new.get_request

Collection.all.destroy_all
Deck.all.destroy_all
%w(Basic Classic Promo Reward Naxxramas Goblins\ vs\ Gnomes Blackrock\ Mountain The\ Grand\ Tournament The\ League\ of\ Explorers Whispers\ of\ the\ Old\ Gods Karazhan).each do |collection_name|
    collection = Collection.new name: collection_name
    set_cards = result[collection_name]
    set_cards.each do |card|
        collection.cards.build cardId: card['cardId'], name: card['name'], type: card['type'], cost: card['cost'], playerClass: card['playerClass'], rarity: card['rarity'], image: card['img']
    end
    collections << collection
end
Collection.import collections, recursive: true

%w(Promo Reward Naxxramas Goblins\ vs\ Gnomes).each { |collection_name| Collection.find_by(name: collection_name).update(formats: 'wild') }
Card.check_cards_format
Deck.check_format