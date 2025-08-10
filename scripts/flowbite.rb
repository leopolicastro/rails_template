# Get configuration from global config set in interactive_setup.rb
include_flowbite = $template_config[:include_flowbite]

if include_flowbite.downcase.start_with?("y")
  # Debug: Check current directory and file existence
  say "Current directory: #{Dir.pwd}"
  say "Checking for config/importmap.rb..."
  say "File exists: #{File.exist?("config/importmap.rb")}"

  if File.exist?("config/importmap.rb")
    # Add Flowbite to importmap
    append_to_file "config/importmap.rb" do
      <<~RUBY
        
        pin "flowbite", to: "https://cdn.jsdelivr.net/npm/flowbite@3.1.2/dist/flowbite.turbo.min.js"
      RUBY
    end

    # Import Flowbite in application.js
    append_to_file "app/javascript/application.js" do
      "\nimport 'flowbite';\n"
    end

    say "Flowbite has been added! You can now use Flowbite components in your views."
  else
    say "ERROR: config/importmap.rb not found!"
  end
else
  say ""
  say "⚠️  NAVBAR DROPDOWN NOTICE"
  say "=" * 50
  say "Your navbar includes a user dropdown that requires JavaScript to function."
  say "Without Flowbite, the dropdown button won't work."
  say ""
  say "CHOOSE ONE OPTION:"
  say ""
  say "1. ADD FLOWBITE MANUALLY LATER:"
  say "   • Add to config/importmap.rb:"
  say "     pin \"flowbite\", to: \"https://cdn.jsdelivr.net/npm/flowbite@3.1.2/dist/flowbite.turbo.min.js\""
  say "   • Add to app/javascript/application.js:"
  say "     import 'flowbite';"
  say ""
  say "2. REPLACE WITH SIMPLE BUTTONS:"
  say "   • Edit app/views/application/_dropdown.html.erb"
  say "   • Remove dropdown structure, add separate logout/admin buttons"
  say ""
  say "3. IMPLEMENT CUSTOM DROPDOWN WITH STIMULUS:"
  say "   • Create a Stimulus controller for dropdown toggle functionality"
  say "   • Edit app/views/application/_dropdown.html.erb"
  say "   • Replace data-dropdown-toggle with data-controller=\"dropdown\" and Stimulus actions"
  say ""
  say "=" * 50
  say ""
end

