say "Installing custom scaffold templates..."

# Create the lib/templates directory structure
empty_directory "lib/templates/erb/scaffold"
empty_directory "lib/templates/rails/scaffold_controller"
empty_directory "lib/templates/rails/credentials"

# Copy view template files
view_template_files = [
  "_form.html.erb.tt",
  "edit.html.erb.tt",
  "index.html.erb.tt",
  "new.html.erb.tt",
  "partial.html.erb.tt",
  "show.html.erb.tt"
]

view_template_files.each do |template_file|
  source_file = "templates/lib/generators/scaffold/templates/#{template_file}"
  target_file = "lib/templates/erb/scaffold/#{template_file}"
  copy_file source_file, target_file
end

# Copy controller template file
controller_source = "templates/lib/templates/rails/scaffold_controller/controller.rb.tt"
controller_target = "lib/templates/rails/scaffold_controller/controller.rb"
copy_file controller_source, controller_target

# Copy credentials template file
credentials_source = "templates/lib/templates/rails/credentials/credentials.yml.tt"
credentials_target = "lib/templates/rails/credentials/credentials.yml.tt"
copy_file credentials_source, credentials_target

say "✅ Custom scaffold templates installed!"
say "📝 View templates: lib/templates/erb/scaffold/"
say "📝 Controller template: lib/templates/rails/scaffold_controller/"
say "📝 Credentials template: lib/templates/rails/credentials/"
say ""
say "Features included:"
say "• Tailwind CSS styling for forms and views"
say "• Enhanced error handling with styled error messages"
say "• Professional form layouts with proper spacing"
say "• Consistent styling across all scaffold views"
say "• Custom controller template with your preferred structure"
say "• Enhanced credentials template with Active Record encryption and cloud storage setup"
say ""
say "Next steps:"
say "• Run 'rails generate scaffold ModelName field:type' to use custom templates"
say "• Run 'rails credentials:edit' to use the enhanced credentials template"
say "• Both views and controllers will use your custom templates automatically"
