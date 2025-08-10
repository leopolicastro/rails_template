gem "view_component"
gem "pagy"

gem_group :development do
  gem "standard", ">= 1.35.1", require: false
  gem "ruby-lsp"
  gem "hotwire-livereload"
  gem "htmlbeautfier", require: false
end

gem_group :development, :test do
  gem "faker"
end
