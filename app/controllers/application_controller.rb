class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_filter :set_locale

    private
    
    def get_access
        render template: 'welcome/index' unless current_user
    end

    def render_404
        render template: 'layouts/404', status: 404
    end

    def set_locale
        session[:locale] == 'ru'  || session[:locale] == 'en' ? I18n.locale = session[:locale] : I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
        @locale = I18n.locale
    end
end
