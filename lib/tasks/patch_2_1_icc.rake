namespace :patching do
    desc 'Update cards'
    task patch_2_1_icc: :environment do
        Card.find_by(name_en: 'Fiery War Axe').update(cost: 3)
        Card.find_by(name_en: 'Hex').update(cost: 4)
        Card.find_by(name_en: 'Spreading Plague').update(cost: 6)
    end
end