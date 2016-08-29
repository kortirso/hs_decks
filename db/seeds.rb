if Collection.all.size == 0
    collections = []
    result = Message.new.get_request

    Collection.all.destroy_all
    Deck.all.destroy_all
    [['Basic', 'Базовый набор'], ['Classic', 'Классический набор'], ['Promo', 'Награды'], ['Reward', 'Призовые карты'], ['Naxxramas', 'Наксрамас'], ['Goblins vs Gnomes', 'Гоблины и Гномы'], ['Blackrock Mountain', 'Черная Гора'], ['The Grand Tournament', 'Большой Турнир'], ['The League of Explorers', 'Лига Исследователей'], ['Whispers of the Old Gods', 'Древние Боги'], ['Karazhan', 'Каражан']].each do |collection_name|
        collection = Collection.new name_en: collection_name[0], name_ru: collection_name[1]
        set_cards = result[collection_name[0]]
        set_cards.each do |card|
            collection.cards.build cardId: card['cardId'], name_en: card['name'], type: card['type'], cost: card['cost'], playerClass: card['playerClass'], rarity: card['rarity'], image_en: card['img']
        end
        collections << collection
    end
    Collection.import collections, recursive: true

    %w(Promo Reward Naxxramas Goblins\ vs\ Gnomes).each { |collection_name| Collection.find_by(name_en: collection_name).update(formats: 'wild') }
    Card.check_cards_format
    Deck.check_format
end

#substitutions for legendaries

card_id = Card.find_by(cardId: 'OG_131').id # Twin Emperor Vek'lor
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'EX1_032').id, priority: 9 # for Sunwalker
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'EX1_178').id, priority: 10 # or Ancient of War

card_id = Card.find_by(cardId: 'OG_080').id # Xaril
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'EX1_278').id, priority: 10 # for Shiv

card_id = Card.find_by(cardId: 'EX1_110').id # Cairne Bloodhoof
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'EX1_032').id, priority: 10 # for Sunwalker
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'CS2_200').id, priority: 9 # or Boulderfist Ogre

card_id = Card.find_by(cardId: 'EX1_558').id # Harrison Jones
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'EX1_066').id, priority: 10 # for Acidic Swamp Ooze

card_id = Card.find_by(cardId: 'EX1_002').id # The Black Knight
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'EX1_048').id, priority: 10 # for Spellbreaker
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'NEW1_041').id, priority: 8 # or Stampeding Kodo

card_id = Card.find_by(cardId: 'EX1_298').id # Ragnaros the Firelord
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'CS2_213').id, priority: 8 # for Reckless Rocketeer
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'OG_153').id, priority: 10 # or Bog Creeper
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'CS2_200').id, priority: 9 # or Boulderfist Ogre

card_id = Card.find_by(cardId: 'EX1_116').id # Leeroy Jenkins
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'EX1_089').id, priority: 9 # for Reckless Rocketeer
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'CS2_213').id, priority: 10 # or Arcane Golem

card_id = Card.find_by(cardId: 'EX1_016').id # Sylvanas Windrunner
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'EX1_032').id, priority: 10 # for Sunwalker
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'CS2_200').id, priority: 9 # or Boulderfist Ogre

card_id = Card.find_by(cardId: 'EX1_614').id # Illidan Stormrage
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'NEW1_026').id, priority: 9 # for Violet Teacher
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'EX1_597').id, priority: 10 # or Imp Master

card_id = Card.find_by(cardId: 'EX1_577').id # The Beast
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'CS2_201').id, priority: 9 # for Core Hound

card_id = Card.find_by(cardId: 'EX1_572').id # Ysera
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'CS2_200').id, priority: 9 # for Boulderfist Ogre

card_id = Card.find_by(cardId: 'OG_340').id # Soggoth the Slitherer
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'OG_153').id, priority: 10 # for Bog Creeper

card_id = Card.find_by(cardId: 'EX1_012').id # Bloodmage Thalnos
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'CS2_142').id, priority: 9 # for Kobold Geomancer
Shift.create card_id: card_id, change_id: Card.find_by(cardId: 'EX1_096').id, priority: 10 # or Loot Hoarder