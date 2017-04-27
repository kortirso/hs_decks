class CollectionsController < ApplicationController
    before_action :get_access

    def create
        UploadCollectionJob.perform_later({user: current_user, username: shift_params[:username]})
    end

    private

    def shift_params
        params.permit(:username)
    end
end
