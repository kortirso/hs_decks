module Subs
    class DefineSubsService
        attr_reader :user_collection, :substitution, :deck_cards, :search_engine

        def initialize(args)
            @user_collection = args[:user_collection]
        end

        def search_subs(args)
            select_data_from_deck(args)
            deck_cards.each_key do |card_id|
                if user_collection.key?(card_id)
                    search_engine.find_exchange(card_id, 1) if user_collection[card_id] < deck_cards[card_id][:amount]
                else
                    search_engine.find_exchange(card_id, deck_cards[card_id][:amount])
                end
            end
            update_check
        end

        private

        def select_data_from_deck(args)
            @substitution = Substitution.create check: args[:check]
            @deck_cards = args[:deck].positions.collect_ids_with_rarity_as_hash
            @search_engine = Subs::SearchSubsService.new({deck: args[:deck], deck_cards: deck_cards, user_collection: user_collection})
        end

        def update_check(lines = [], t = Time.current)
            search_engine.cards_in_deck.each { |key, amount| lines.push "('#{key}', #{substitution.id}, 'Substitution', '#{amount}', '#{nil}', '#{t}', '#{t}')" unless amount.nil? }
            Position.connection.execute "INSERT INTO positions (card_id, positionable_id, positionable_type, amount, caption, created_at, updated_at) VALUES #{lines.join(", ")}"
        end
    end
end