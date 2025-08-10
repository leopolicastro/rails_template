# Copy navbar template to application views
copy_file "templates/app/views/application/_navbar.html.erb", "app/views/application/_navbar.html.erb"

# Replace "Your App" with the actual app name
app_title = app_name.titleize
gsub_file "app/views/application/_navbar.html.erb", "Your App", app_title

# Add navbar to application layout
inject_into_file "app/views/layouts/application.html.erb", after: "<body>\n" do
  <<~ERB
    <%= render 'navbar' %>
    
  ERB
end