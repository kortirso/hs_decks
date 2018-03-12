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

    cards << Card.new(cardId: card['cardId'], dbfid: card['dbfId'], name: { en: card['name'], ru: '' }, type: card['type'], cost: card['cost'], playerClass: card['playerClass'], rarity: card['rarity'], formats: 'standard', craft: card['craft'], collection_id: collection.id, player_id: player_list.rassoc(card['playerClass'])[0], multi_class_id: (card['multiClassGroup'].nil? ? nil : multis_list.rassoc(card['multiClassGroup'])[0]), multiClassGroup: (card['multiClassGroup'].nil? ? '' : card['multiClassGroup']), attack: card['attack'], health: card['health'], mechanics: (mechs.size.zero? ? nil : mechs), race_id: (card['race'].nil? ? nil : races_list.rassoc(card['race'])[0]), race_name: card['race'])
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

# update cards ids
cards_file = JSON.parse(File.read("#{Rails.root}/lib/tasks/data/patch_1_ungoro.json"))
cards_file.each do |card|
  current_card = Card.find_by_locale_name('en', card['name_en'])
  current_card.update(cardId: card['cardId'])
end

cards_file = JSON.parse(File.read("#{Rails.root}/lib/tasks/data/patch_2_kobolds.json"))
cards_file.each do |card|
  current_card = Card.find_by_locale_name('en', card['name_en'])
  current_card.update(cardId: card['cardId'])
end

if About.all.size.zero?
  about1 = About.create version: '0.2', label_en: 'Version - 0.2, 20.08.2016', label_ru: 'Версия - 0.2 от 20.08.2016'
  Fix.create about: about1, body_en: "Selecting cards in the collection is carried out on the 'Cards collection', or a specific page with deck (at the moment there is no technical possibility to automatically download a collection of players cards).", body_ru: "Выбор карт в коллекцию осуществляется на странице 'Коллекция карт' или на странице определенной колоды (на данный момент нет технической возможности для автоматической загрузки коллекции карт игроков)."
  Fix.create about: about1, body_en: 'Additional filters in the collection of maps to facilitate the search.', body_ru: 'Дополнительные фильтры в коллекции карт для упрощения поиска.'
  Fix.create about: about1, body_en: 'View expert decks with description, mana curve and images of all the cards.', body_ru: 'Просмотр экспертных колод с описанием, кривой маны и изображениями всех карт.'
  Fix.create about: about1, body_en: 'Analyzing the decks for the successful filling of the existing collection cards with automatic calculation of the replacement of the missing cards.', body_ru: 'Анализирование колод на успешное заполнение существующими в коллекции картами с автоматическим расчетом карт на замену отсутствующих.'
  Fix.create about: about1, body_en: 'Additional filters for more targeted analysis of the decks.', body_ru: 'Дополнительные фильтры для более узконаправленного анализа колод.'
  Fix.create about: about1, body_en: 'Viewing deck check, displays the data on the source deck for the missing cards and a deck with a view of a replacement card.', body_ru: 'Просмотр проверки колоды, выводятся данные по исходной колоде, по отсутствующим картам и по колоде с учетом замен карт.'
  Fix.create about: about1, body_en: 'The interface for creating, editing and deleting of expert decks.', body_ru: 'Интерфейс для создания, редактирования и удаления экспертных колод.'
  Fix.create about: about1, body_en: 'Russian and English localizations.', body_ru: 'Русская и английская локализации.'
  Fix.create about: about1, body_en: 'Test version of replacement system.', body_ru: 'Тестовая версия системы поиска замен карт.'
  about2 = About.create version: '0.3', label_en: 'Version - 0.3, 14.09.2016', label_ru: 'Версия - 0.3 от 14.09.2016'
  Fix.create about: about2, body_en: 'Slightly redesigned interface for easy navigation between pages.', body_ru: 'Немного переработан интерфейс для упрощения навигации по страницам.'
  Fix.create about: about2, body_en: 'Name and classes are now displayed in Russian.', body_ru: 'Названия коллекций и классов теперь выводятся на русском языке.'
  Fix.create about: about2, body_en: 'Added displaying the description for the check card in the deck.', body_ru: 'Добавлен вывод описания для карт в проверочной колоде.'
  Fix.create about: about2, body_en: 'Added parameter showing the strength of deck.', body_ru: 'Добавлен параметр, указывающий силу колод.'
  Fix.create about: about2, body_en: 'You can add cards to the collection by clicking on the map on page viewing decks.', body_ru: 'Можно добавлять карты в коллекцию, кликом на карту, на странице просмотра колод.'
  Fix.create about: about2, body_en: 'Bug fixnig.', body_ru: 'Исправление ошибок.'
  about3 = About.create version: '0.4', label_en: 'Version - 0.4, 10.10.2016', label_ru: 'Версия - 0.4 от 10.10.2016'
  Fix.create about: about3, body_en: 'Relocation to deckhunter.ru.', body_ru: 'Переезд на домен deckhunter.ru.'
  Fix.create about: about3, body_en: 'Added multilevel exchange system.', body_ru: 'Добавлена многоуровневая система подбора замен для карт.'
  Fix.create about: about3, body_en: 'Added mailers for new users and newsletters.', body_ru: 'Добавлена почтовая рассылка для новых пользователей и новостей.'
  Fix.create about: about3, body_en: 'Added filters for expert decks.', body_ru: 'Добавлен фильтр экспертных колод.'
  Fix.create about: about3, body_en: 'Added list of unused cards for dust.', body_ru: 'Добавлен список неиспользуемых карт для распыления.'
  Fix.create about: about3, body_en: 'Bug fixnig.', body_ru: 'Исправление ошибок.'
  about4 = About.create version: '0.4.1', label_en: 'Version - 0.4.1, 22.10.2106', label_ru: 'Версия - 0.4.1 от 22.10.2106'
  Fix.create about: about4, body_en: 'Import card collection from Hearthpwn.', body_ru: 'Импорт коллекции карт с Hearthpwn.'
  Fix.create about: about4, body_en: 'Add forms for shifts creation for experts.', body_ru: 'Добавлены формы создания замен для экспертов.'
  Fix.create about: about4, body_en: 'Bug fixing.', body_ru: 'Исправление ошибок.'
end

if Shift.all.size.zero?
  # substitutions for legendaries
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
end
