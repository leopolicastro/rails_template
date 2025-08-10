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
  # Run StandardRB to fix code formatting
  run "bundle exec standardrb --fix"

  # Run htmlbeautifier on ERB files
  say "Running htmlbeautifier on ERB files..."
  run "bundle exec htmlbeautifier **/*.erb"
  say "✅ ERB files formatted with htmlbeautifier"
end
