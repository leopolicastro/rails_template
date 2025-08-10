# Get configuration from global config set in interactive_setup.rb
include_madmin = $template_config[:include_madmin]

if include_madmin.downcase.start_with?("y")
  say "Installing Madmin gem..."
  run "bundle add madmin"

  say "Running Madmin generator..."
  generate "madmin:install"

  # Modify routes to use /admin path instead of /madmin
  routes_file = "config/routes/madmin.rb"
  if File.exist?(routes_file)
    say "Configuring Madmin to use /admin path..."
    gsub_file routes_file, "namespace :madmin do", "namespace :madmin, path: :admin do"
  end

  # Configure authentication in the generated controller
  controller_file = "app/controllers/madmin/application_controller.rb"
  if File.exist?(controller_file)
    say "Configuring authentication for Madmin..."
    
    # Include Authentication module
    inject_into_file controller_file, after: "class ApplicationController < Madmin::BaseController\n" do
      "  include Authentication\n"
    end
    
    # Enable admin authentication check
    gsub_file controller_file,
      "# redirect_to \"/\", alert: \"Not authorized.\" unless authenticated? && Current.user.admin?",
      "redirect_to \"/\", alert: \"Not authorized.\" unless authenticated? && Current.user.admin?"
  end

  say "✅ Madmin installation completed!"
  say "📝 Admin interface available at: /admin"
  say "🔐 Simple authentication is enabled - users must be logged in to access"
  say "Harden authentication by updating the authenticate_admin_user method."
  say "Next steps:"
  say "• Customize your admin resources in app/madmin/resources/"
  say "• Modify authentication logic in app/controllers/madmin/application_controller.rb"
  say "• Visit /admin after starting your Rails server"
end

