test_framework = ask("Do you want to use RSpec instead of Minitest? (y/n)")
include_factories = ask("Do you want to use FactoryBot for test factories? (y/n)")
include_shoulda = ask("Do you want to include shoulda-matchers for enhanced test matchers? (y/n)")

# Add shoulda-matchers gem if requested
if include_shoulda.downcase.start_with?("y")
  gem_group :test do
    gem "shoulda-matchers", "~> 6.0"
  end
end

# Add factory_bot gem if requested
if include_factories.downcase.start_with?("y")
  gem_group :development, :test do
    gem "factory_bot_rails"
  end
end

run "bundle install"

# Create dynamic generators.rb based on choices
if test_framework.downcase.start_with?("y")
  # RSpec generators configuration
  create_file "config/initializers/generators.rb", <<~RUBY
    Rails.application.config.generators do |g|
      g.test_framework :rspec,
        fixtures: #{include_factories.downcase.start_with?("y") ? "false" : "true"},
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        request_specs: true,
        controller_specs: false,
        model_specs: true

      g.helper = false
      g.assets = false
      #{include_factories.downcase.start_with?("y") ? "g.fixture_replacement :factory_bot, dir: 'spec/factories'" : ""}
    end
  RUBY

  # Add RSpec gem and install
  gem_group :development, :test do
    gem "rspec-rails", git: "https://github.com/rspec/rspec-rails"
  end
  run "bundle install"
  generate "rspec:install"

  # Configure shoulda-matchers for RSpec if requested
  if include_shoulda.downcase.start_with?("y")
    inject_into_file "spec/rails_helper.rb", after: "require 'rspec/rails'\n" do
      "\nrequire 'shoulda-matchers'\n\nShouda::Matchers.configure do |config|\n  config.integrate do |with|\n    with.test_framework :rspec\n    with.library :rails\n  end\nend\n"
    end
  end

  # Configure FactoryBot for RSpec if requested
  if include_factories.downcase.start_with?("y")
    inject_into_file "spec/rails_helper.rb", after: "require 'rspec/rails'\n" do
      "\nrequire 'factory_bot_rails'\n"
    end

    inject_into_file "spec/rails_helper.rb", after: "RSpec.configure do |config|\n" do
      "\n  # Include FactoryBot methods\n  config.include FactoryBot::Syntax::Methods\n"
    end
  end
else
  # Minitest generators configuration
  create_file "config/initializers/generators.rb", <<~RUBY
    Rails.application.config.generators do |g|
      g.test_framework :minitest,
        fixtures: #{include_factories.downcase.start_with?("y") ? "false" : "true"},
        view_tests: false,
        helper_tests: false,
        controller_tests: false,
        integration_tests: true,
        model_tests: true

      g.helper = false
      g.assets = false
      # g.system_tests = nil # uncomment to stop generating test/system files

      #{include_factories.downcase.start_with?("y") ? "g.fixture_replacement :factory_bot, dir: 'test/factories'" : ""}
    end
  RUBY

  # Configure shoulda-matchers for Minitest if requested
  if include_shoulda.downcase.start_with?("y")
    inject_into_file "test/test_helper.rb", after: "fixtures :all\n" do
      "\nrequire 'shoulda-matchers'\n\nShouda::Matchers.configure do |config|\n  config.integrate do |with|\n    with.test_framework :minitest\n    with.library :rails\n  end\nend\n"
    end
  end

  # Configure FactoryBot for Minitest if requested
  if include_factories.downcase.start_with?("y")
    inject_into_file "test/test_helper.rb", after: "fixtures :all\n" do
      "\n    # Include FactoryBot methods\n    include FactoryBot::Syntax::Methods\n"
    end
  end
end
