namespace :patching do
    desc 'Modifying cards with attack, health, race, mechanics'
    task patch_1_2_ungoro: :environment do
        # add races
        [['Murloc', 'Мурлок'], ['Beast', 'Зверь'], ['Demon', 'Демон'], ['Totem', 'Тотем'], ['Elemental', 'Элементаль'], ['Pirate', 'Пират'], ['Dragon', 'Дракон'], ['Mech', 'Механизм']].each do |race|
            Race.create name_en: race[0], name_ru: race[1]
        end

        # add data to minion cards
        races = Race.all.collect { |r| [r.name_en, r.id] }
        result = Message.new().get_request
        ["Basic", "Classic", "Promo", "Hall of Fame", "Naxxramas", "Goblins vs Gnomes", "Blackrock Mountain", "The Grand Tournament", "The League of Explorers", "Whispers of the Old Gods", "One Night in Karazhan", "Mean Streets of Gadgetzan", "Journey to Un'Goro"].each do |collection|
            result[collection].select { |card| card['type'] == 'Minion' }.each do |card|
                real_card = Card.find_by(name_en: card['name'])
                next if real_card.nil?
                mechs = []
                card['mechanics'].each { |mech| mechs.push mech['name'] } unless card['mechanics'].nil?
                real_card.update(attack: card['attack'], health: card['health'], mechanics: (mechs.size.zero? ? nil : mechs), race_id: (card['race'].nil? ? nil : races.assoc(card['race'])[1]), race_name: card['race'])
            end
        end
    end
end