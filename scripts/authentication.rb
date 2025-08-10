# Get configuration from global config set in interactive_setup.rb
include_auth = $template_config[:include_auth]

if include_auth.downcase.start_with?("y")
  generate "authentication"

  # Add admin boolean column to users table
  generate "migration", "AddAdminToUsers", "admin:boolean"

  # Update the migration to set default and null constraints
  migration_file = Dir.glob("db/migrate/*_add_admin_to_users.rb").first
  if migration_file
    gsub_file migration_file, "add_column :users, :admin, :boolean", "add_column :users, :admin, :boolean, default: false, null: false"
  end

  # Generate User factory if FactoryBot is configured
  if File.exist?("config/initializers/generators.rb") && File.read("config/initializers/generators.rb").include?("factory_bot")
    generate "factory_bot:model", "User", "email_address:string", "password:string"
  end

  # Create AdminController
  create_file "app/controllers/admin_controller.rb" do
    <<~RUBY
      class AdminController < ApplicationController
        before_action :require_admin

        private

         def request_authentication
          session[:return_to_after_authenticating] = request.url
          redirect_to "/session/new"
        end


        def require_admin
          redirect_to root_path, alert: "Not authorized." unless Current.user&.admin?
        end
      end
    RUBY
  end

  rails_command "db:migrate"

  # Add admin user to seeds file
  append_to_file "db/seeds.rb" do
    <<~RUBY

      # Create admin user
      User.create(
        email_address: "admin@example.com",
        password: "abc123",
        admin: true
      )

      puts "Admin user created: admin@example.com / abc123"
    RUBY
  end

  # Run seeds to create admin user
  rails_command "db:seed"
end
