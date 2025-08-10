# Rails Application Template

A comprehensive Rails application template that sets up a modern Rails application with authentication, testing, UI components, and development tools.

## Quick Start

Create a new Rails application using this template:

```bash
rails new myapp -m https://raw.githubusercontent.com/leopolicastro/rails_template/main/template.rb
```

Or if you have the template locally:

```bash
rails new myapp -m /path/to/template.rb
```

## Features

### 🔐 Authentication

- **Rails Authentication**: Generates optional authentication system with User model
- **Ready-to-use**: Creates admin user for immediate testing (`admin@example.com` / `abc123`)

### 🎨 UI Components

- **Navbar**: Simmple responsive navigation with login/logout functionality
- **Flash Alerts**: Styled notice and alert messages with Tailwind CSS
- **Flowbite**: Optional Flowbite integration

### 🧪 Test Suite

- **Framework Choice**: Interactive selection between RSpec and Minitest
- **Test Factories**: Optional FactoryBot integration for test data
- **Shoulda Matchers**: Optional shoulda matchers for RSpec or Minitest

### 📦 Core Gems

- **View Component**: Component-based view architecture
- **Pagy**: Fast and lightweight pagination
- **Action Text**: Rich text content editing
- **Active Storage**: File upload and processing

### 🛠 Development Tools

- **StandardRB**: Ruby style guide and linter
- **Ruby LSP**: Language server for IDE integration
- **Hotwire LiveReload**: Automatic browser refresh during development
- **RuboCop**: Code style enforcement with custom configuration

### 📄 Content Management

- **Action Text**: Rich text editing with Trix editor
- **Active Storage**: File attachment handling
- **Image Processing**: Built-in image variant support

### 📊 Pagination

- **Pagy Integration**: High-performance pagination
- **Helper Methods**: Pre-configured in ApplicationHelper
- **Backend Support**: Included in ApplicationController

## Interactive Setup

During template execution, you'll be prompted for:

- **Test Framework**: Choose between RSpec or Minitest
- **Test Factories**: Enable FactoryBot for test data generation
- **Authentication**: Include user authentication system
- **Controller Name**: Customize your main controller (Home/Dashboard/Main)
- **Active Storage**: Configure file storage service

## Requirements

- Ruby 3.0+

## Usage

### With Custom Options

The template will interactively ask for your preferences:

- Test framework preference
- Whether to include FactoryBot
- Authentication setup confirmation
- Controller naming preferences

### Post-Setup

After template completion:

1. Run `bin/db setup` to set up the database and start server
2. Visit `http://localhost:3000`
3. Login with `admin@example.com` / `abc123` (If you chose authentication)

## License

This project is available as open source under the terms of the MIT License.
