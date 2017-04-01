namespace :patching do
    desc 'loading base database'
    task :base_data do
        # create player classes
        [['Priest', 'Жрец'], ['Warrior', 'Воин'], ['Warlock', 'Чернокнижник'], ['Mage', 'Маг'], ['Druid', 'Друид'], ['Hunter', 'Охотник'], ['Shaman', 'Шаман'], ['Paladin', 'Паладин'], ['Rogue', 'Разбойник'], ['Neutral', 'Нейтральный']].each do |player|
            Player.create name_en: player[0], name_ru: player[1]
        end
        Player.find_by(name_en: 'Neutral').update(playable: false)

        # create multi classes
        [['Grimy Goons', 'Ржавые Бугаи', ['Warrior', 'Hunter', 'Paladin']], ['Jade Lotus', 'Нефритовый Лотус', ['Druid', 'Shaman', 'Rogue']], ['Kabal', 'Кабал', ['Priest', 'Warlock', 'Mage']]].each do |multi|
            multi_class = MultiClass.create name_en: multi[0], name_ru: multi[1]
            multi[2].each { |m| Player.find_by(name_en: m).update(multi_class_id: multi_class.id) }
        end

        # create collections
        [['Basic', 'Базовый набор'], ['Classic', 'Классический набор'], ['Promo', 'Награды'], ['Reward', 'Призовые карты'], ['Naxxramas', 'Наксрамас'], ['Goblins vs Gnomes', 'Гоблины и Гномы'], ['Blackrock Mountain', 'Черная Гора'], ['The Grand Tournament', 'Большой Турнир'], ['The League of Explorers', 'Лига Исследователей'], ['Whispers of the Old Gods', 'Древние Боги'], ['Karazhan', 'Каражан'], ['Mean Streets of Gadgetzan', 'Злачный город Прибамбасск']].each do |collection_name|
            Collection.create name_en: collection_name[0], name_ru: collection_name[1]
        end

        # update collections
        %w(Promo Reward Naxxramas Goblins\ vs\ Gnomes).each { |c| Collection.find_by(name_en: c).set_as_wild }
        %w(Naxxramas Blackrock\ Mountain The\ League\ of\ Explorers Karazhan).each { |c| Collection.find_by(name_en: c).set_as_adventure }

        # create deck styles
        [['Aggro', 'Агро'], ['Control', 'Контроль'], ['Midrange', 'Мидрейндж'], ['Tempo', 'Темпо'], ['Combo', 'Комбо'], ['Token', 'Токен'], ['Ramp', 'Рамп'], ['Fatique', 'Фатиг'], ['Mill', 'Милл']].each do |style|
            Style.create name_en: style[0], name_ru: style[1]
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