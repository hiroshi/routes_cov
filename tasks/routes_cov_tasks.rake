require File.dirname(__FILE__) + "/../lib/routes_cov"

# desc "check coverage of routes in test"
# task :routes_cov do
#   RoutesCov.puts_results
# end

Rake::Task.class_eval do
  def invoke_with_routes_cov(*args)
    RoutesCov.trace_action(:task => @name) do
      invoke_without_routes_cov(*args)
    end
  end
  alias_method_chain :invoke, :routes_cov
end

at_exit do
  RoutesCov.puts_results
end

