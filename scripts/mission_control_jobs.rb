# Get configuration from global config set in interactive_setup.rb
include_jobs = $template_config[:include_jobs]

if include_jobs.downcase.start_with?("y")
  say "Installing Mission Control Jobs gem..."
  run "bundle add mission_control-jobs"

  # Configure routes - mount inside madmin namespace if it exists, otherwise in main routes
  madmin_routes_file = "config/routes/madmin.rb"
  main_routes_file = "config/routes.rb"

  if File.exist?(madmin_routes_file)
    say "Mounting Mission Control Jobs in admin namespace..."
    # Insert the mount inside the madmin namespace block
    inject_into_file madmin_routes_file, after: "namespace :madmin, path: :admin do\n" do
      "  mount MissionControl::Jobs::Engine, at: \"/jobs\"\n"
    end
  else
    say "Mounting Mission Control Jobs in main routes..."
    # Mount in main routes file
    inject_into_file main_routes_file, after: "Rails.application.routes.draw do\n" do
      "  mount MissionControl::Jobs::Engine, at: \"/jobs\"\n"
    end
  end

  # Configure application.rb for custom authentication
  application_file = "config/application.rb"
  if File.exist?(application_file)
    say "Configuring custom authentication for Mission Control Jobs..."

    # Use AdminController if it exists, otherwise use ApplicationController
    base_controller = File.exist?("app/controllers/admin_controller.rb") ? "AdminController" : "ApplicationController"

    inject_into_file application_file, before: /^  end$/ do
      <<~RUBY

        # Mission Control Jobs configuration
        config.mission_control.jobs.base_controller_class = "#{base_controller}"
        config.mission_control.jobs.http_basic_auth_enabled = false
      RUBY
    end
  end

  say "✅ Mission Control Jobs installation completed!"

  if File.exist?(madmin_routes_file)
    say "📊 Jobs dashboard available at: /admin/jobs"
    say "🔗 Access through your admin interface"
  else
    say "📊 Jobs dashboard available at: /jobs"
  end

  say "🔐 Using your app's authentication system"
  say ""
  say "Next steps:"
  say "• Start your Rails server and visit the jobs dashboard"
  say "• Set up a job queue adapter (Solid Queue, Resque, etc.)"
  say "• Monitor and manage your background jobs through the web interface"
end

