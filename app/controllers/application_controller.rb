class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # before_actionでdeviseのストロングパラメータに、nameカラムを追加するメソッドを実行します。dive08で追記したよ。
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :current_notifications, if: :signed_in?

  def current_notifications
    @notifications_count = Notification.where(user_id: current_user.id).where(read: false).count
  end

  PERMISSIBLE_ATTRIBUTES = %i(name avatar avatar_cache)

  private

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: PERMISSIBLE_ATTRIBUTES)
      devise_parameter_sanitizer.permit(:account_update, keys: PERMISSIBLE_ATTRIBUTES)
    end

  # dive13で追記したよ。例外処理
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, :alert => exception.message
  end
end
