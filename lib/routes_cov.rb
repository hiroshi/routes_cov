module RoutesCov
  @@only = ["test:functionals"] # FIXME: to be customizable
  LOG_PATH = Pathname.new(Rails.root).join("tmp","routes_cov") # Rials.root is a String in Rails 2.2.2....

  def self.included(base)
    base.alias_method_chain :perform_action, :routes_cov
  end

  def perform_action_with_routes_cov
    if LOG_PATH.exist?
      LOG_PATH.open("a"){|f| f.puts "#{self.controller_path}##{self.action_name}"}
    end
    perform_action_without_routes_cov
  end

  def self.trace_action(options={}, &block)
    if @@only.include?(options[:task])
      LOG_PATH.open("w+"){}
    end
    yield
  end

  def self.puts_results
    if LOG_PATH.exist?
      performed = LOG_PATH.readlines.uniq.map(&:chomp)
      LOG_PATH.unlink
      routed = ActionController::Routing::Routes.routes.map do |route|
        "#{route.requirements[:controller]}##{route.requirements[:action]}"
      end
      unperformed = routed - performed
      if unperformed.empty?
        puts "\nRoutesCov: Congrats! There is no unpeformed action."
      else
        puts "\nRoutesCov: There are unpeformed actions here:"
        unperformed.each{|e| puts e }
      end
    end
  end
end
