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

collect_message("Custom scaffold templates installed", :completion)
collect_message("Enhanced scaffold templates available with Tailwind CSS styling", :info)
collect_message("Run 'rails generate scaffold ModelName field:type' to use custom templates", :instruction)
