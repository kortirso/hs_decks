class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :check_access
    before_action :locale

    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404

    def catch_404
        raise ActionController::RoutingError.new(params[:path]), 'error'
    end

    private

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation) }
    end

    def check_access
        render_404 unless current_user
    end

    def check_user_role
        render_404 unless current_user.deck_master?
    end

    def render_404
        render template: 'layouts/404', status: 404
    end

    def locale
        @locale = :ru
    end
end
