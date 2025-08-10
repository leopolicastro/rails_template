# Get configuration from global config set in interactive_setup.rb
include_madmin = $template_config[:include_madmin]

if include_madmin.downcase.start_with?("y")
  run "bundle add madmin"
  generate "madmin:install"

  # Modify routes to use /admin path instead of /madmin
  routes_file = "config/routes/madmin.rb"
  if File.exist?(routes_file)
    # Configure to use /admin path
    gsub_file routes_file, "namespace :madmin do", "namespace :madmin, path: :admin do"
  end

  # Configure authentication in the generated controller
  controller_file = "app/controllers/madmin/application_controller.rb"
  if File.exist?(controller_file)
    # Configure authentication
    
    # Include Authentication module
    inject_into_file controller_file, after: "class ApplicationController < Madmin::BaseController\n" do
      "  include Authentication\n"
    end
    
    # Enable admin authentication check
    gsub_file controller_file,
      "# redirect_to \"/\", alert: \"Not authorized.\" unless authenticated? && Current.user.admin?",
      "redirect_to \"/\", alert: \"Not authorized.\" unless authenticated? && Current.user.admin?"
  end

  collect_message("Madmin admin interface installed", :completion)
  collect_message("Admin interface available at: /admin", :info)
  collect_message("Customize admin resources in app/madmin/resources/", :instruction)
  collect_message("Modify authentication in app/controllers/madmin/application_controller.rb", :instruction)
end

