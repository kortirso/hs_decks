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
    %w(Promo Hall\ of\ Fame Naxxramas Goblins\ vs\ Gnomes Blackrock\ Mountain The\ Grand\ Tournament The\ League\ of\ Explorers).each { |c| Collection.find_by_locale_name('en', c).set_as_wild }
    %w(Naxxramas Blackrock\ Mountain The\ League\ of\ Explorers One\ Night\ in\ Karazhan).each { |c| Collection.find_by_locale_name('en', c).set_as_adventure }

    # create deck styles
    [['Aggro', 'Агро'], ['Control', 'Контроль'], ['Midrange', 'Мидрейндж'], ['Tempo', 'Темпо'], ['Combo', 'Комбо'], ['Token', 'Токен'], ['Ramp', 'Рамп'], ['Fatique', 'Фатиг'], ['Mill', 'Милл']].each do |style|
      Style.create(name: { en: style[0], ru: style[1] })
    end

    # create cards
    cards_file = File.read("#{Rails.root}/lib/tasks/data/base_data.json")
    cards = []
    collection_list = Collection.all.collect{ |c| [c.id, c.name_en] }
    player_list = Player.all.collect{ |p| [p.id, p.name_en] }
    multis_list = MultiClass.all.collect{ |p| [p.id, p.name_en] }
    JSON.parse(cards_file).each do |card|
      cards << Card.new(cardId: card['cardId'], name_en: card['name_en'], name_ru: card['name_ru'], type: card['type'], cost: card['cost'], playerClass: card['playerClass'], rarity: card['rarity'], formats: card['formats'], craft: card['craft'], hall_of_fame: card['hall_of_fame'], collection_id: collection_list.rassoc(card['collection']['name_en'])[0], player_id: player_list.rassoc(card['playerClass'])[0], multi_class_id: (card['multiClassGroup'].nil? ? nil : multis_list.rassoc(card['multiClassGroup'])[0]), multiClassGroup: card['multiClassGroup'])
    end
    Card.import cards
  end
end