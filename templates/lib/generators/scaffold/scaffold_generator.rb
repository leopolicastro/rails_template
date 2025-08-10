class ScaffoldGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  # Run rails:scaffold with the same arguments and options
  hook_for :scaffold, in: :rails, default: true, type: :boolean

  def turbo_refreshes
    return if behavior == :revoke

    inject_into_class File.join("app/models", class_path, "#{file_name}.rb"), class_name do
      "  broadcasts_refreshes\n"
    end
  end
end
