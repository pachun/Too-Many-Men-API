# active admin controllers inherit from ApplicationController, and they rely
# on ApplicationController inheriting from ActionController::Base; not
# ActionController::API.
#
# We created ApiController for our apps controllers to inherit from.
class ApiController < ActionController::API
end
