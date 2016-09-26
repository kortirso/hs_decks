class AccountsController < ApplicationController
    before_action :get_access

    def create
        current_user.build_collection(collection_params)
    end

    private

    def collection_params
        params.permit!.to_h
    end
end
