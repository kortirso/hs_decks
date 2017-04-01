namespace :patching do
    desc 'Loading cards for collection Journey To Ungoro'
    task patch_1_1_ungoro: :environment do
        # updating collections
        ['Blackrock Mountain', 'The Grand Tournament', 'The League of Explorers'].each { |c| Collection.find_by(name_en: c).set_as_wild }
    end
end