require "routes_cov"
if Rails.env == "test"
  ActionController::Base.send(:include, RoutesCov)
end
