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

collect_message("Sorting system installed", :completion)
