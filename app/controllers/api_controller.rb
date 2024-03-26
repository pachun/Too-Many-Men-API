# active admin controllers inherit from ApplicationController, and they rely
# on ApplicationController inheriting from ActionController::Base; not
# ActionController::API.
#
# We created ApiController for our apps controllers to inherit from.
class ApiController < ActionController::API
  def authenticate_player
    return head :unauthorized unless current_player
  end

  def current_player
    @current_player ||= Player.find_by(api_token: request.headers["ApiToken"])
  end
end
