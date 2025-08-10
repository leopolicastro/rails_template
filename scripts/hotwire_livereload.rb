# Configure Hotwire Livereload by updating stylesheet link tag
gsub_file "app/views/layouts/application.html.erb",
  /<%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>/,
  '<%= stylesheet_link_tag "application", "data-turbo-track": Rails.env.production? ? "reload" : "" %>'

