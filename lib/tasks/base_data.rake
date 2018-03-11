namespace :patching do
  desc 'loading base database'
  task base_data: :environment do
    # create multi classes and players
    [['Grimy Goons', 'Ржавые Бугаи', [['Warrior', 'Воин'], ['Hunter', 'Охотник'], ['Paladin', 'Паладин']]], ['Jade Lotus', 'Нефритовый Лотус', [['Druid', 'Друид'], ['Shaman', 'Шаман'], ['Rogue', 'Разбойник']]], ['Kabal', 'Кабал', [['Priest', 'Жрец'], ['Warlock', 'Чернокнижник'], ['Mage', 'Маг']]]].each do |multi|
      multi_class = MultiClass.create(name: { en: multi[0], ru: multi[1]})
      multi[2].each { |player| Player.create(name: { en: player[0], ru: player[1] }, multi_class_id: multi_class.id) }
    end
    Player.create(name: { en: 'Neutral', ru: 'Нейтральный' }, playable: false)

    # create collections
    [['Basic', 'Базовый набор'], ['Classic', 'Классический набор'], ['Promo', 'Награды'], ['Hall of Fame', 'Зал славы'], ['Naxxramas', 'Наксрамас'], ['Goblins vs Gnomes', 'Гоблины и Гномы'], ['Blackrock Mountain', 'Черная Гора'], ['The Grand Tournament', 'Большой Турнир'], ['The League of Explorers', 'Лига Исследователей'], ['Whispers of the Old Gods', 'Древние Боги'], ['One Night in Karazhan', 'Вечеринка в Каражане'], ['Mean Streets of Gadgetzan', 'Злачный город Прибамбасск'], ["Journey to Un'Goro", "Экспедиция в Ун'Горо"], ['Knights of the Frozen Throne', 'Рыцари Ледяного Трона'], ['Kobolds & Catacombs', 'Кобольды и катакомбы']].each do |collection_name|
      Collection.create(name: { en: collection_name[0], ru: collection_name[1] })
    end

    # update collections
    %w(Naxxramas Blackrock\ Mountain The\ League\ of\ Explorers One\ Night\ in\ Karazhan).each { |c| Collection.find_by_locale_name('en', c).set_as_adventure }

    # create deck styles
    [['Aggro', 'Агро'], ['Control', 'Контроль'], ['Midrange', 'Мидрейндж'], ['Tempo', 'Темпо'], ['Combo', 'Комбо'], ['Token', 'Токен'], ['Ramp', 'Рамп'], ['Fatique', 'Фатиг'], ['Mill', 'Милл']].each do |style|
      Style.create(name: { en: style[0], ru: style[1] })
    end

    # add races
    [['Murloc', 'Мурлок'], ['Beast', 'Зверь'], ['Demon', 'Демон'], ['Totem', 'Тотем'], ['Elemental', 'Элементаль'], ['Pirate', 'Пират'], ['Dragon', 'Дракон'], ['Mech', 'Механизм']].each do |race|
      Race.create(name: { en: race[0], ru: race[1] })
    end

    # create cards
    cards_list = CardCollectionService.new.get_cards
    cards = []
    player_list = Player.all.collect{ |p| [p.id, p.locale_name('en')] }
    multis_list = MultiClass.all.collect{ |p| [p.id, p.locale_name('en')] }
    races_list = Race.all.collect { |r| [r.id, r.locale_name('en') ] }

    Collection.all.each do |collection|
      collection_name = collection.locale_name('en')
      cards_list[collection_name].each do |card|
        mechs = []
        card['mechanics'].each { |mech| mechs.push mech['name'] } unless card['mechanics'].nil?

        cards << Card.new(cardId: card['cardId'], dbfid: card['dbfId'], name: { en: card['name'], ru: '' }, type: card['type'], cost: card['cost'], playerClass: card['playerClass'], rarity: card['rarity'], formats: 'standard', craft: card['craft'], collection_id: collection.id, player_id: player_list.rassoc(card['playerClass'])[0], multi_class_id: (card['multiClassGroup'].nil? ? nil : multis_list.rassoc(card['multiClassGroup'])[0]), multiClassGroup: card['multiClassGroup'], attack: card['attack'], health: card['health'], mechanics: (mechs.size.zero? ? nil : mechs), race_id: (card['race'].nil? ? nil : races_list.rassoc(card['race'])[0]), race_name: card['race'])
      end
    end
    Card.import cards

    # set cards as wild
    %w(Promo Hall\ of\ Fame Naxxramas Goblins\ vs\ Gnomes Blackrock\ Mountain The\ Grand\ Tournament The\ League\ of\ Explorers).each { |c| Collection.find_by_locale_name('en', c).set_as_wild }
    Collection.adventures.of_format('wild').each { |c| c.cards.update_all(craft: true) }

    # update russian names for cards
    cards_list = CardCollectionService.new('ru').get_cards
    Collection.all.each do |collection|
      collection_name = collection.locale_name('en')
      cards_list[collection_name].each do |card|
        current_card = Card.find_by(dbfid: card['dbfId'])
        name = current_card.name
        name['ru'] = card['name']
        current_card.update(name: name)
      end
    end
  end
end
