# frozen_string_literal: true

# Render MJML mailer templates via the mrml gem (prebuilt Rust binary) instead
# of shelling out to Node's mjml npm package at runtime. Enabling use_mrml
# makes mjml_binary_version_supported/mjml_binary/minify/beautify/
# validation_level all no-ops - mrml has its own fixed rendering behavior.
Mjml.setup do |config|
  config.use_mrml = true
end
