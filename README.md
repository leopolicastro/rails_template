# Rails Application Template

A comprehensive Rails application template that sets up a modern Rails application with authentication, testing, UI components, and development tools.

## Prerequisites & Setup

### Recommended: Copy .railsrc File

For the best experience, copy the included `.railsrc` file to your home directory:

```bash
curl https://raw.githubusercontent.com/leopolicastro/rails_template/refs/heads/main/templates/.railsrc > ~/.railsrc
```

This configures Rails to:

- Use **TailwindCSS** by default (`--css=tailwind`)
- Skip **RuboCop** setup (`--skip-rubocop`) since this template uses StandardRB
- Automatically apply this template to new apps

After copying `.railsrc`, simply run:

```bash
rails new myapp
```

### Manual Usage (without .railsrc)

If you prefer not to use `.railsrc`, run:

```bash
rails new myapp --css=tailwind --skip-rubocop -m https://raw.githubusercontent.com/leopolicastro/rails_template/refs/heads/main/template.rb
```

### Important Notes

- **TailwindCSS**: This template is specifically designed for Tailwind CSS applications
- **StandardRB**: Uses StandardRB instead of RuboCop for code formatting

## Interactive Setup

During template execution, you'll be prompted for:

- **Test Framework**: Choose between RSpec or Minitest
- **Test Factories**: Enable FactoryBot for test data generation
- **Authentication**: Include user authentication system
- **Controller Name**: Customize your main controller (Home/Dashboard/Main)
- **Active Storage**: Configure file storage service
- **Action Text**: Configure for rich text content

## Requirements

- Ruby 3.0+

## Usage

### Post-Setup

After template completion:

1. Run `bin/db setup` to set up the database and start server
2. Visit `http://localhost:3000`
3. Login with `admin@example.com` / `abc123` (If you chose authentication)

## License

This project is available as open source under the terms of the MIT License.
