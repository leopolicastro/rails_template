say "=" * 80
say "🚀 Welcome to the Rails Template Setup!"
say "Let's configure your new Rails application."
say "This will take just a minute, then everything will run automatically."
say "=" * 80
say ""

# Testing Framework Configuration
say "📋 TESTING FRAMEWORK"
say "-" * 20
@use_rspec = ask("Do you want to use RSpec instead of Minitest? (y/n)")
@include_factories = ask("Do you want to use FactoryBot for test factories? (y/n)")
@include_shoulda = ask("Do you want to include shoulda-matchers for enhanced test matchers? (y/n)")
say ""

# Authentication & Admin
say "🔐 AUTHENTICATION & ADMIN"
say "-" * 25
@include_auth = ask("Do you want to include authentication? (y/n)")
if @include_auth.downcase.start_with?("y")
  @include_madmin = ask("Do you want to install Madmin admin interface? (y/n)")
  @include_jobs = ask("Do you want to install Mission Control Jobs for background job management? (y/n)")
else
  @include_madmin = "n"
  @include_jobs = "n"
end
say ""

# UI & Components
say "🎨 UI & COMPONENTS"
say "-" * 17
@include_flowbite = ask("Do you want to set up Flowbite (Tailwind CSS components)? (y/n)")
@controller_name = ask("What would you like to call your main controller? (Home/Dashboard/Main or custom name) [Default: Home]:")
@controller_name = "Home" if @controller_name.blank?
say ""

# Features & Storage
say "⚡ FEATURES & STORAGE"
say "-" * 20
@include_action_text = ask("Do you want to set up Action Text? (y/n)")
@include_storage = ask("Do you want to set up Active Storage? (y/n)")
if @include_storage.downcase.start_with?("y")
  @storage_type = ask("Do you want to use local storage or S3? (local/s3)")
  if @storage_type.downcase.start_with?("s3")
    @service_name = ask("What's your cloud storage service name? (e.g., linode, aws, digitalocean)")
    @use_s3_in_dev = ask("Do you want to use #{@service_name} in development too? (y/n)")
  end
end
say ""

# Configuration Summary
say "=" * 80
say "📋 CONFIGURATION SUMMARY"
say "=" * 80
say "🧪 Testing Framework: #{@use_rspec.downcase.start_with?('y') ? 'RSpec' : 'Minitest'}"
say "🏭 FactoryBot: #{@include_factories.downcase.start_with?('y') ? 'Yes' : 'No'}"
say "🔍 Shoulda Matchers: #{@include_shoulda.downcase.start_with?('y') ? 'Yes' : 'No'}"
say "🔐 Authentication: #{@include_auth.downcase.start_with?('y') ? 'Yes' : 'No'}"
if @include_auth.downcase.start_with?("y")
  say "👑 Madmin Admin: #{@include_madmin.downcase.start_with?('y') ? 'Yes' : 'No'}"
  say "⚙️  Mission Control Jobs: #{@include_jobs.downcase.start_with?('y') ? 'Yes' : 'No'}"
end
say "🎨 Flowbite Components: #{@include_flowbite.downcase.start_with?('y') ? 'Yes' : 'No'}"
say "🏠 Main Controller: #{@controller_name}"
say "📝 Action Text: #{@include_action_text.downcase.start_with?('y') ? 'Yes' : 'No'}"
if @include_storage.downcase.start_with?("y")
  say "💾 Active Storage: Yes (#{@storage_type.downcase.start_with?('s3') ? @service_name || 'S3' : 'Local'})"
  if @storage_type.downcase.start_with?("s3") && @use_s3_in_dev.downcase.start_with?("y")
    say "   └── Development: #{@service_name}"
  end
else
  say "💾 Active Storage: No"
end
say "=" * 80
say ""

proceed = ask("Continue with this configuration? (y/n)")
if !proceed.downcase.start_with?("y")
  say "❌ Setup cancelled. You can run the template again anytime."
  exit 1
end

say ""
say "🎉 Great! Starting installation with your configuration..."
say "Sit back and relax - this may take a few minutes."
say "=" * 80
say ""

# Store configuration in global variables for other scripts to access
$template_config = {
  use_rspec: @use_rspec,
  include_factories: @include_factories,
  include_shoulda: @include_shoulda,
  include_auth: @include_auth,
  include_madmin: @include_madmin,
  include_jobs: @include_jobs,
  include_flowbite: @include_flowbite,
  controller_name: @controller_name,
  include_action_text: @include_action_text,
  include_storage: @include_storage,
  storage_type: @storage_type,
  service_name: @service_name,
  use_s3_in_dev: @use_s3_in_dev
}