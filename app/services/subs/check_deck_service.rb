module Subs
    class CheckDeckService
        attr_reader :user_collection, :check, :deck_cards

        def initialize(args)
            @user_collection = args[:user_collection]
        end

        def check_deck(args, result = 0, dust = 0, lines = [], t = Time.current)
            select_data_from_deck(args)
            deck_cards.each_key do |card_id|
                amount, caption = 0, nil
                if user_collection.key?(card_id)
                    amount = user_collection[card_id] >= deck_cards[card_id][:amount] ? 2 : 1
                    result += deck_cards[card_id][:amount] - (2 - amount)
                end
                if amount < 2
                    checker = check_crafted({card_id: card_id, amount: (2 - amount)})
                    dust += checker[:dust]
                    caption = checker[:caption]
                end
                lines.push "('#{card_id.to_i}', #{check.id}, 'Check', '#{amount}', '#{caption}', '#{t}', '#{t}')"
            end
            update_check({result: result, dust: dust, lines: lines})
        end

        private

        def select_data_from_deck(args)
            @check = args[:check]
            @deck_cards = args[:deck].positions.collect_ids_with_rarity_as_hash
        end

        def check_crafted(args)
            if deck_cards[args[:card_id]][:crafted]
                add_dust = DustPrice.calc(deck_cards[args[:card_id]][:rarity], args[:amount])
                caption = "#{I18n.t('pages.check.main.caption_1')} - #{add_dust}"
            else
                add_dust = 0
                caption = "#{I18n.t('pages.check.main.caption_2')} - #{Card.find(args[:card_id]).collection.locale_name(I18n.locale)}"
            end
            {dust: add_dust, caption: caption}
        end

        def update_check(args)
            check.update(success: args[:result], dust: args[:dust])
            Position.connection.execute "INSERT INTO positions (card_id, positionable_id, positionable_type, amount, caption, created_at, updated_at) VALUES #{args[:lines].join(", ")}"
        end
    end
end