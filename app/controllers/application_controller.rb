class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :set_locale
    protect_from_forgery with: :exception

    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404

    def catch_404
        raise ActionController::RoutingError.new(params[:path])
    end

    private

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation) }
    end
    
    def get_access
        render_404 unless current_user
    end

    def check_user_role
        render_404 unless current_user.deck_master?
    end

    def render_404
        render template: 'layouts/404', status: 404
    end

    def set_locale
        session[:locale] == 'ru' || session[:locale] == 'en' ? I18n.locale = session[:locale] : I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
        @locale = I18n.locale
    end
end
