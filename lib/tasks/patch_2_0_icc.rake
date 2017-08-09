namespace :patching do
    desc 'Loading cards for collection IceCrownCitadel'
    task patch_2_0_icc: :environment do
        # create collection
        collection = Collection.create name_en: 'Knights of the Frozen Throne', name_ru: 'Рыцари Ледяного Трона'

        #loading cards
        cards_file = File.read("#{Rails.root}/lib/tasks/data/patch_2_icc.json")
        cards, player_list = [], Player.all.collect{ |p| [p.id, p.name_en] }
        JSON.parse(cards_file).each do |card|
            cards << Card.new(cardId: card['cardId'], name_en: card['name_en'], name_ru: card['name_ru'], type: card['type'], cost: card['cost'], playerClass: card['playerClass'], rarity: card['rarity'], collection: collection, player_id: player_list.rassoc(card['playerClass'])[0])
        end
        Card.import cards
    end
end