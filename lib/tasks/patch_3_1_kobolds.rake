namespace :patching do
    desc 'Loading cards for collection Kobolds and Catacombs'
    task patch_3_1_kobolds: :environment do
        card = Card.find_by(name_ru: 'К оружию!')
        card.update(name_en: 'Call to Arms')
    end
end