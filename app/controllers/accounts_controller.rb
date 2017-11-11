class AccountsController < ApplicationController
    def create
        CollectionConstructor.new(cards: collection_params, user: current_user).build_collection
    end

    private

    def collection_params
        params.require(:cards).permit!
    end
end
