include_storage = ask("Do you want to set up Active Storage? (y/n)")

if include_storage.downcase.start_with?("y")
  storage_type = ask("Do you want to use local storage or S3? (local/s3)")

  # Common setup for both local and S3
  gsub_file "Gemfile", /# gem "image_processing"/, 'gem "image_processing"'
  rails_command "active_storage:install"
  rails_command "db:migrate"

  if storage_type.downcase.start_with?("s3")
    service_name = ask("What's your cloud storage service name? (e.g., linode, aws, digitalocean)")

    # Add aws-sdk-s3 gem
    gem "aws-sdk-s3"

    # Configure storage.yml with custom service
    inject_into_file "config/storage.yml", after: "# Use bin/rails credentials:edit to set the AWS secrets (as aws:access_key_id|secret_access_key)\n" do
      "\n#{service_name}:\n  service: S3\n  access_key_id: <%= Rails.application.credentials.dig(:#{service_name}, :access_key_id) %>\n  secret_access_key: <%= Rails.application.credentials.dig(:#{service_name}, :secret_access_key) %>\n  region: <%= Rails.application.credentials.dig(:#{service_name}, :region) %>\n  endpoint: <%= Rails.application.credentials.dig(:#{service_name}, :endpoint) %>\n  bucket: <%= Rails.application.credentials.dig(:#{service_name}, :bucket) %>\n\n"
    end

    # Update production.rb to use the custom service
    gsub_file "config/environments/production.rb", /config\.active_storage\.service = :local/, "config.active_storage.service = :#{service_name}"

    # Ask if they want to use S3 in development too
    use_s3_in_dev = ask("Do you want to use #{service_name} in development too? (y/n)")
    if use_s3_in_dev.downcase.start_with?("y")
      gsub_file "config/environments/development.rb", /config\.active_storage\.service = :local/, "config.active_storage.service = :#{service_name}"
    end

    # Display credentials template
    say "\n" + "=" * 80
    say "IMPORTANT: You need to configure your credentials!"
    say "Run: bin/rails credentials:edit --environment=production"
    say "Add this template to your production credentials:"
    say "=" * 80
    say "#{service_name}:"
    say "  access_key_id: your_access_key_here"
    say "  secret_access_key: your_secret_access_key_here"
    say "  region: your_region_here"
    say "  endpoint: your_endpoint_here"
    say "  bucket: your_bucket_name_here"
    say "=" * 80 + "\n"
  end
end