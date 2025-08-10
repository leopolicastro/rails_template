include_flowbite = ask("Do you want to set up Flowbite (Tailwind CSS components)? (y/n)")

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
end

