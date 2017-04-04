class AccountsController < ApplicationController
    before_action :get_access

    def create
        CollectionConstructor.new({cards: collection_params, user: current_user}).build_collection
    end

    private

    def collection_params
        params.require(:cards).permit!
    end
end
