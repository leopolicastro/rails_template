# Get configuration from global config set in interactive_setup.rb
include_action_text = $template_config[:include_action_text]

if include_action_text.downcase.start_with?("y")
  rails_command "action_text:install"
  rails_command "db:migrate"
  collect_message("Action Text rich text editor installed", :completion)
end