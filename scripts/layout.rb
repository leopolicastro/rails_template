# Add dark mode support to application layout
layout_file = "app/views/layouts/application.html.erb"

if File.exist?(layout_file)
  # Add dark mode support to body tag
  gsub_file layout_file, "<body>", '<body class="dark:bg-gray-900 dark:text-white">'

  # Update margin classes for better vertical spacing
  gsub_file layout_file, "mt-28", "my-28"

  # Add Turbo 8 meta tags for enhanced page refreshes
  gsub_file layout_file, "</head>", <<~HEAD
      <meta name="turbo-refresh-method" content="morph">
      <meta name="turbo-refresh-scroll" content="preserve">
    </head>
  HEAD

  collect_message("Dark mode support and enhanced layout configured", :completion)
  collect_message("Turbo 8 page refreshes with enabled", :info)
else
  collect_message("Warning: #{layout_file} not found - layout setup skipped", :warning)
end
