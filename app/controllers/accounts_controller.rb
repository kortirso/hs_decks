class AccountsController < ApplicationController
    before_action :get_access

    def create
        current_user.build_collection(params)
    end
end
