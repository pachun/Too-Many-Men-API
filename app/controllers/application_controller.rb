# active admin controllers inherit from ApplicationController, and they rely
# on ApplicationController inheriting from ActionController::Base; not
# ActionController::API.
#
# We created ApiController for our apps controllers to inherit from.
#
# Since this controller exists entirely for active admin, which is a developer
# tool - not a feature - it is not included in coverage reports

# :nocov:
class ApplicationController < ActionController::Base
  private

  def set_active_admin_display_timezone_to_eastern_time
    Time.use_zone("Eastern Time (US & Canada)") { yield }
  end
end
# :nocov:
