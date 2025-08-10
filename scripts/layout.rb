say "Configuring application layout with dark mode support..."

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

  say "✅ Dark mode support added to application layout!"
  say "✅ Updated margin classes for better spacing!"
  say "✅ Turbo 8 enhanced page refreshes configured!"
  say "📱 Your app now has proper dark mode background and text colors"
  say ""
  say "Layout improvements:"
  say "• Automatic dark background when system/browser is in dark mode"
  say "• Proper text contrast in dark mode"
  say "• Better vertical spacing with margin adjustments"
  say "• Enhanced Turbo 8 page refreshes with morphing (no flicker)"
  say "• Scroll position preservation during page refreshes"
  say "• Works seamlessly with scaffold templates and components"
else
  say "⚠️  Warning: #{layout_file} not found - skipping layout setup"
end
