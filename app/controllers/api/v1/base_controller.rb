class Api::V1::BaseController < ApplicationController
    before_action :doorkeeper_authorize!, only: :current_resource_owner

    protected
    
    def current_resource_owner
        @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    def check_user_role
        render json: { error: 'User is not deck master' } unless current_resource_owner.deck_master?
    end
end