namespace :patching do
    desc 'Loading cards for collection Kobolds and Catacombs'
    task patch_3_0_kobolds: :environment do
        # create collection
        collection = Collection.create name_en: 'Kobolds and Catacombs', name_ru: 'Кобольды и Катакомбы'

        #loading cards
        cards_file = File.read("#{Rails.root}/lib/tasks/data/patch_3_kobolds.json")
        cards, player_list = [], Player.all.collect{ |p| [p.id, p.name_en] }
        JSON.parse(cards_file).each do |card|
            cards << Card.new(cardId: card['cardId'], name_en: card['name_en'], name_ru: card['name_ru'], type: card['type'], cost: card['cost'], playerClass: card['playerClass'], rarity: card['rarity'], collection: collection, player_id: player_list.rassoc(card['playerClass'])[0])
        end
        Card.import cards
    end
end