say "Installing sorting system..."

# Copy ApplicationRecord with sorting methods
copy_file "templates/app/models/application_record.rb", "app/models/application_record.rb", force: true

# Create the concerns directory and copy Orderable controller concern
empty_directory "app/controllers/concerns"
copy_file "templates/app/controllers/concerns/orderable.rb", "app/controllers/concerns/orderable.rb"

# Create the helpers directory and copy SortHelper
empty_directory "app/helpers"
copy_file "templates/app/helpers/sort_helper.rb", "app/helpers/sort_helper.rb"

# Inject Orderable into ApplicationController
inject_into_class "app/controllers/application_controller.rb", "ApplicationController", <<~RUBY
  include Orderable
RUBY

say "✅ Sorting system installed!"
say "📝 ApplicationRecord: Enhanced with sort_by_params and sortable_columns methods"
say "📝 Orderable concern: app/controllers/concerns/orderable.rb"
say "📝 SortHelper: app/helpers/sort_helper.rb"
say "📝 ApplicationController: Includes Orderable concern"
say ""
say "Features included:"
say "• Safe column sorting with allowlist protection"
say "• Modern SVG icons with accessibility support"
say "• Clean separation: controller logic in concern, view helpers in helper module"
say "• Automatic integration with scaffold generators"
say ""
say "Usage in controllers:"
say "• Model.sort_by_params(sort_column(Model), sort_direction)"
say "Usage in views:"
say "• sort_link(relation, :column_name, 'Display Name')"
say ""
