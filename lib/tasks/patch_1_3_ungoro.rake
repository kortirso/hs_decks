namespace :patching do
    desc 'Make cards crafted from old collections'
    task patch_1_3_ungoro: :environment do
        Collection.adventures.of_format('wild').each do |c|
            c.cards.update_all(craft: true)
        end
    end
end