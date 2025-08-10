# Copy alerts template to application views
copy_file "templates/app/views/application/_alerts.html.erb", "app/views/application/_alerts.html.erb"

# Add alerts to application layout
inject_into_file "app/views/layouts/application.html.erb", after: "<%= render 'navbar' %>\n" do
  <<~ERB
    <%= render 'alerts' %>
  ERB
end