# Get configuration from global config set in interactive_setup.rb
include_jobs = $template_config[:include_jobs]

if include_jobs.downcase.start_with?("y")
  run "bundle add mission_control-jobs"

  # Configure routes - mount inside madmin namespace if it exists, otherwise in main routes
  madmin_routes_file = "config/routes/madmin.rb"
  main_routes_file = "config/routes.rb"

  if File.exist?(madmin_routes_file)
    # Mount in admin namespace
    # Insert the mount inside the madmin namespace block
    inject_into_file madmin_routes_file, after: "namespace :madmin, path: :admin do\n" do
      "  mount MissionControl::Jobs::Engine, at: \"/jobs\"\n"
    end
  else
    # Mount in main routes
    # Mount in main routes file
    inject_into_file main_routes_file, after: "Rails.application.routes.draw do\n" do
      "  mount MissionControl::Jobs::Engine, at: \"/jobs\"\n"
    end
  end

  # Configure application.rb for custom authentication
  application_file = "config/application.rb"
  if File.exist?(application_file)
    # Configure authentication

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

  collect_message("Mission Control Jobs installed", :completion)
  
  if File.exist?(madmin_routes_file)
    collect_message("Jobs dashboard available at: /admin/jobs", :info)
  else
    collect_message("Jobs dashboard available at: /jobs", :info)
  end
  
  collect_message("Set up a job queue adapter (Solid Queue, Resque, etc.)", :instruction)
  collect_message("Visit the jobs dashboard to monitor background jobs", :instruction)
end

