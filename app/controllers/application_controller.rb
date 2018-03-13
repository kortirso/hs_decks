class ApplicationController < ActionController::Base
  prepend_view_path Rails.root.join('frontend')
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_access
  before_action :locale

  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def catch_404
    raise ActionController::RoutingError.new(params[:path]), 'error'
  end

  private def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation) }
  end

  private def check_access
    render_404 unless current_user
  end

  private def check_user_role
    render_404 unless current_user.deck_master?
  end

  private def render_404
    render template: 'layouts/404', status: 404
  end

  private def locale
    @locale = params[:locale]
  end
end
