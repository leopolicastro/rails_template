# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a Rails application template that automates the setup of modern Rails applications with authentication, testing frameworks, UI components, and development tools. The template uses an interactive, modular approach to let users customize their Rails app setup.

## Common Commands

### Template Usage
```bash
# Remote usage (recommended)
rails new myapp --css=tailwind --skip-rubocop -m https://raw.githubusercontent.com/leopolicastro/rails_template/main/template.rb

# With .railsrc file (after copying to ~/.railsrc)
rails new myapp

# Local development/testing
rails new myapp -m template.rb
```

### Development Workflow
```bash
# Format code (this template uses StandardRB, not RuboCop)
bundle exec standardrb --fix

# Test the template locally
rails new test_app -m template.rb
cd test_app
bin/rails server
```

## Architecture Overview

### Modular Script System
The template uses a modular architecture with specialized scripts in the `scripts/` directory:

- **Core Setup**: `gems.rb`, `rubocop_file.rb`
- **Testing**: `test_suite.rb` (RSpec/Minitest with FactoryBot/Shoulda)
- **Authentication**: `authentication.rb` (Rails 8 authentication + admin user)
- **UI Components**: `navbar.rb`, `alerts.rb`, `layout.rb`
- **Features**: `pagy.rb`, `action_text.rb`, `active_storage_setup.rb`
- **Development Tools**: `hotwire_livereload.rb`
- **Admin Tools**: `madmin.rb`, `mission_control_jobs.rb`
- **Customization**: `scaffolds.rb`, `home_page.rb`
- **Cleanup**: `gemfile_cleanup.rb`

### Execution Flow
1. `template.rb` handles remote/local setup via `setup_template`
2. Pre-bundle scripts: gems and rubocop configuration
3. Post-bundle scripts: interactive setup of features and components
4. Final cleanup and code formatting

### Interactive Configuration
The template prompts users for preferences:
- Test framework (RSpec vs Minitest)
- Test factories (FactoryBot)
- Authentication system inclusion
- Controller naming (Home/Dashboard/Main)
- Admin interface (Madmin)
- Enhanced test matchers (Shoulda)

## Custom Scaffold System

The template installs enhanced scaffold generators with:
- **Location**: `lib/templates/erb/scaffold/` and `lib/templates/rails/scaffold_controller/`
- **Features**: TailwindCSS styling, enhanced error handling, professional layouts
- **Templates**: `_form.html.erb.tt`, `index.html.erb.tt`, `show.html.erb.tt`, etc.
- **Usage**: Standard `rails generate scaffold ModelName field:type` automatically uses custom templates

## Key Components

### Authentication System
- Uses Rails 8 authentication generator
- Creates admin boolean column with migration
- Generates `AdminController` with `require_admin` before_action
- Seeds admin user: `admin@example.com` / `abc123`
- Integrates with navbar for login/logout

### Testing Configuration
- Dynamic `config/initializers/generators.rb` based on user choices
- RSpec: request specs enabled, controller/view specs disabled
- Minitest: integration and model tests enabled
- FactoryBot integration when selected
- Shoulda matchers configuration for both frameworks

### UI & Styling
- TailwindCSS-first approach (required via .railsrc)
- Flowbite components integration (optional)
- Responsive navbar with authentication states
- Flash message alerts styling
- Pagy pagination with TailwindCSS styling

## Development Notes

### Code Standards
- **StandardRB**: Used instead of RuboCop for code formatting
- **Ruby LSP**: Included for IDE integration
- **Hotwire LiveReload**: Auto-refresh during development

### Gem Strategy
- **View Component**: Component-based architecture
- **Pagy**: High-performance pagination over Kaminari
- **Faker**: Test data generation
- **Action Text**: Rich text editing with Trix

### Configuration Files
- `.railsrc`: Standardizes Rails new command options
- `config/initializers/generators.rb`: Dynamically created based on test framework choice
- `config/initializers/pagy.rb`: Downloaded from official Pagy repo

## Template Maintenance

When modifying scripts:
1. Keep interactive prompts user-friendly
2. Handle both positive responses ("y", "yes", "Yes") in downcase comparisons
3. Maintain cleanup operations in `gemfile_cleanup.rb`
4. Run StandardRB fix at the end of template execution
5. Use `say` for user feedback and progress indicators

The template is designed to be non-destructive and flexible, allowing users to skip components they don't need while maintaining a cohesive, production-ready Rails application structure.