# Configure Pagy pagination
get "https://ddnexus.github.io/pagy/gem/config/pagy.rb", "config/initializers/pagy.rb"

# Add Pagy::Backend to ApplicationController
inject_into_file "app/controllers/application_controller.rb", after: "class ApplicationController < ActionController::Base\n" do
  "  include Pagy::Backend\n"
end

# Add Pagy::Frontend to ApplicationHelper
inject_into_file "app/helpers/application_helper.rb", after: "module ApplicationHelper\n" do
  "  include Pagy::Frontend\n"
end

# Add pagy navigation to application layout
inject_into_file "app/views/layouts/application.html.erb", after: "    </main>\n" do
  <<~ERB
      
    <% if defined?(@pagy) && @pagy.count > 1 %>
        <%# Note the double equals sign "==" which marks the output as trusted and html safe: %>
        <div class="py-4 flex justify-center w-full">
          <%== pagy_nav(@pagy) %>
        </div>
      <% end %>
  ERB
end

# Download pagy CSS
get "https://ddnexus.github.io/pagy/gem/stylesheets/pagy.css", "app/assets/stylesheets/pagy.css"
