# Get configuration from global config set in interactive_setup.rb
include_flowbite = $template_config[:include_flowbite]

if include_flowbite.downcase.start_with?("y")
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

    collect_message("Flowbite components installed and configured", :completion)
  else
    collect_message("ERROR: config/importmap.rb not found - Flowbite setup failed", :warning)
  end
else
  collect_message("NAVBAR DROPDOWN REQUIRES ATTENTION: Your navbar dropdown needs JavaScript to function. Options: 1) Add Flowbite manually later, 2) Replace with simple buttons, 3) Implement custom Stimulus dropdown. Edit app/views/application/_dropdown.html.erb", :warning)
end

