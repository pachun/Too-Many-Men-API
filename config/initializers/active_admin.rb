ActiveAdmin.setup do |config|
  config.site_title = "Too Many Men Api"
  config.authentication_method = :authenticate_admin_user!
  config.logout_link_path = :destroy_admin_user_session_path
  config.batch_actions = true
  config.filter_attributes = [:encrypted_password, :password, :password_confirmation]
  config.localize_format = :long
  config.around_action :set_active_admin_display_timezone_to_eastern_time
end
