class CollectionsController < ApplicationController
    def create
        UploadCollectionJob.perform_later(user: current_user, username: shift_params[:username])
    end

    private

    def shift_params
        params.permit(:username)
    end
end
