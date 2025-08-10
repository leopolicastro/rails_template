# Setup for remote execution - clone repository to temp directory if running from URL
def setup_template
  if __FILE__.match?(%r{\Ahttps?://})
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("rails-template-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/leopolicastro/rails_template.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{rails_template/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

setup_template

# Initialize message collection system
$template_messages = []

# Helper method to collect important messages for display at the end
def collect_message(message, category = :info)
  $template_messages << {message: message, category: category}
end

# Collect all user preferences upfront
apply "scripts/interactive_setup.rb"

apply "scripts/gems.rb"
apply "scripts/rubocop_file.rb"

after_bundle do
  apply "scripts/test_suite.rb"
  apply "scripts/hotwire_livereload.rb"
  apply "scripts/pagy.rb"
  apply "scripts/flowbite.rb"
  apply "scripts/home_page.rb"
  apply "scripts/authentication.rb"
  apply "scripts/madmin.rb"
  apply "scripts/mission_control_jobs.rb"
  apply "scripts/sorting.rb"
  apply "scripts/scaffolds.rb"
  apply "scripts/layout.rb"
  apply "scripts/navbar.rb"
  apply "scripts/alerts.rb"
  apply "scripts/active_storage_setup.rb"
  apply "scripts/action_text.rb"
  # Clean up Gemfile to consolidate duplicate gem groups
  apply "scripts/gemfile_cleanup.rb"
  # Run StandardRB to fix code formatting (non-blocking)
  if system("bundle exec standardrb --fix")
    say "✅ StandardRB initial formatting completed"
  else
    say "⚠️  StandardRB formatting had issues (continuing anyway)"
  end
  say "🔄 Preparing final summary..."

  # Display collected messages at the end
  say ""
  say "=" * 80
  say "🎉 RAILS TEMPLATE SETUP COMPLETED!"
  say "=" * 80
  say ""

  # Group messages by category
  completion_messages = $template_messages.select { |m| m[:category] == :completion }
  warning_messages = $template_messages.select { |m| m[:category] == :warning }
  instruction_messages = $template_messages.select { |m| m[:category] == :instruction }
  info_messages = $template_messages.select { |m| m[:category] == :info }

  # Display completion messages
  unless completion_messages.empty?
    say "✅ INSTALLATION SUMMARY:"
    completion_messages.each { |msg| say "   #{msg[:message]}" }
    say ""
  end

  # Display important instructions
  unless instruction_messages.empty?
    say "📋 IMPORTANT NEXT STEPS:"
    instruction_messages.each { |msg| say "   #{msg[:message]}" }
    say ""
  end

  # Display warnings
  unless warning_messages.empty?
    say "⚠️  IMPORTANT NOTICES:"
    warning_messages.each { |msg| say "   #{msg[:message]}" }
    say ""
  end

  # Display other info messages
  unless info_messages.empty?
    say "ℹ️  ADDITIONAL INFORMATION:"
    info_messages.each { |msg| say "   #{msg[:message]}" }
    say ""
  end

  say "=" * 80
  say "🚀 Your Rails application is ready to use!"
  say "Run: bin/dev"
  say "=" * 80

  say ""
  say "🎉 Template setup complete! Your Rails app is ready to go!"
end
