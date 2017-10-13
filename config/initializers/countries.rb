# Only USA and Canada are supported, so only load the two locales
ISO3166.configure do |config|
  config.locales = [:ca, :us]
end