module Api
    module V1
        class BaseController < ApplicationController
            private

            def check_user_role
                render json: { error: 'User is not deck master' } unless current_resource_owner.deck_master?
            end
        end
    end
end
