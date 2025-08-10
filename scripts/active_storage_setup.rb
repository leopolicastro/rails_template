# Get configuration from global config set in interactive_setup.rb
include_storage = $template_config[:include_storage]

if include_storage.downcase.start_with?("y")
  storage_type = $template_config[:storage_type]

  # Common setup for both local and S3
  gsub_file "Gemfile", /# gem "image_processing"/, 'gem "image_processing"'
  rails_command "active_storage:install"
  rails_command "db:migrate"

  if storage_type.downcase.start_with?("s3")
    service_name = $template_config[:service_name]

    # Add aws-sdk-s3 gem
    gem "aws-sdk-s3"

    # Configure storage.yml with custom service
    inject_into_file "config/storage.yml", after: "# Use bin/rails credentials:edit to set the AWS secrets (as aws:access_key_id|secret_access_key)\n" do
      "\n#{service_name}:\n  service: S3\n  access_key_id: <%= Rails.application.credentials.dig(:#{service_name}, :access_key_id) %>\n  secret_access_key: <%= Rails.application.credentials.dig(:#{service_name}, :secret_access_key) %>\n  region: <%= Rails.application.credentials.dig(:#{service_name}, :region) %>\n  endpoint: <%= Rails.application.credentials.dig(:#{service_name}, :endpoint) %>\n  bucket: <%= Rails.application.credentials.dig(:#{service_name}, :bucket) %>\n\n"
    end

    # Update production.rb to use the custom service
    gsub_file "config/environments/production.rb", /config\.active_storage\.service = :local/, "config.active_storage.service = :#{service_name}"

    # Ask if they want to use S3 in development too
    use_s3_in_dev = $template_config[:use_s3_in_dev]
    if use_s3_in_dev.downcase.start_with?("y")
      gsub_file "config/environments/development.rb", /config\.active_storage\.service = :local/, "config.active_storage.service = :#{service_name}"
    end

    # Collect credentials configuration message
    collect_message("Active Storage with #{service_name} configured", :completion)
    collect_message("IMPORTANT: Configure your #{service_name} credentials with: bin/rails credentials:edit --environment=production", :instruction)
    collect_message("Add #{service_name} credentials: access_key_id, secret_access_key, region, endpoint, bucket", :instruction)
  else
    collect_message("Active Storage with local storage configured", :completion)
  end
end