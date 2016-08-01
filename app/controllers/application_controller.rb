class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    private
    
    def get_access
        render template: 'welcome/index' unless current_user
    end

    def render_404
        render template: 'layouts/404', status: 404
    end
end
