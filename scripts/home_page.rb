controller_name = ask("What would you like to call your main controller? (Home/Dashboard/Main or custom name) [Default: Home]:")

# Default to Home if they just press enter
controller_name = "Home" if controller_name.strip.empty?

# Capitalize the first letter to ensure proper class naming
controller_name = controller_name.strip.capitalize

generate "controller", controller_name, "show"

# Remove the auto-generated route (e.g., get "dashboard/show")
gsub_file "config/routes.rb", /^\s*get\s+["']#{controller_name.downcase}\/show["'].*\n/, ""

# Set root route with chosen controller
route "root '#{controller_name.downcase}#show'"

