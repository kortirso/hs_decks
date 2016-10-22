class CollectionsController < ApplicationController
    before_action :get_access

    def create
        current_user.hearthpwn_collection(shift_params)
    end

    private

    def shift_params
        params.permit(:username)
    end
end
