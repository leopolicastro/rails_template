include_action_text = ask("Do you want to set up Action Text? (y/n)")

if include_action_text.downcase.start_with?("y")
  rails_command "action_text:install"
  rails_command "db:migrate"
end