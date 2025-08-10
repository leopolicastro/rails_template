# Get configuration from global config set in interactive_setup.rb
controller_name = $template_config[:controller_name]

# Capitalize the first letter to ensure proper class naming
controller_name = controller_name.strip.capitalize

generate "controller", controller_name, "show"

# Remove the auto-generated route (e.g., get "dashboard/show")
gsub_file "config/routes.rb", /^\s*get\s+["']#{controller_name.downcase}\/show["'].*\n/, ""

# Set root route with chosen controller
route "root '#{controller_name.downcase}#show'"

