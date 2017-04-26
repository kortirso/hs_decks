module Subs
    class SearchService
        attr_reader :user, :user_collection, :deck_cards, :check_params, :check

        def initialize(args)
            @user = args[:user]
            @user_collection = user.positions.collect_ids_as_hash
            @check_params = args[:params].to_h
        end

        def call
            destroy_previous_checks
            check_deck_service = Subs::CheckDeckService.new({user_collection: user_collection})
            define_subs_service = Subs::DefineSubsService.new({user_collection: user_collection})

            Subs::SelectDecksService.call(check_params).each do |deck|
                check = user.checks.create deck: deck, success: 0
                check_deck_service.check_deck({deck: deck, check: check})
                #define_subs_service.search_subs({deck: deck, check: check})
            end
        end

        private

        def destroy_previous_checks
            user.checks.destroy_all
        end
    end
end