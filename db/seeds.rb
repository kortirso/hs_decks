collections = []
result = Message.new.get_request

Collection.all.destroy_all
%w(Basic Classic Promo Reward Naxxramas Goblins\ vs\ Gnomes Blackrock\ Mountain The\ Grand\ Tournament The\ League\ of\ Explorers Whispers\ of\ the\ Old\ Gods).each do |name|
    collection = Collection.new name: name
    set_cards = result[name]
    set_cards.each do |card|
        collection.cards.build cardId: card['cardId'], name: card['name'], type: card['type'], cost: card['cost'], playerClass: card['playerClass'], rarity: card['rarity']
    end
    collections << collection
end
Collection.import collections, recursive: true