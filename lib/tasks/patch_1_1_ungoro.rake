namespace :patching do
    desc 'Loading cards for collection Journey To Ungoro'
    task patch_1_1_ungoro: :environment do
        # updating old collections
        ['Blackrock Mountain', 'The Grand Tournament', 'The League of Explorers'].each { |c| Collection.find_by(name_en: c).set_as_wild }

        # put cards to Hall of Fame
        ['Azure Drake', 'Sylvanas Windrunner', 'Ragnaros the Firelord', 'Power Overwhelming', 'Ice Lance', 'Conceal'].each { |c| Card.find_by(name_en: c).put_in_hall_of_fame }

        # update decks
        Deck.all.each { |d| d.check_deck_format }
    end
end