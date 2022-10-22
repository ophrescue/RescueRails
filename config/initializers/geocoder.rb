Geocoder.configure(
  # Geocoding options
  timeout: 3,                 # geocoding service timeout (secs)

  lookup: :amazon_location_service,            # name of geocoding service (symbol)
  amazon_location_service: {
    index_name: 'OPH_PROD'
  },
  language: :en,              # ISO-639 language code

  use_https: true,            # use HTTPS for lookup requests? (if supported)

  # cache: nil,                 # cache object (must respond to #[], #[]=, and #keys)
  # cache_prefix: 'geocoder:',  # prefix (string) to use for all cache keys

  # Exceptions that should not be rescued by default
  # (if you want to implement custom error handling);
  # supports SocketError and TimeoutError
  # always_raise: [],

  # Calculation options
  units: :mi,                 # :km for kilometers or :mi for miles
  distances: :linear          # :spherical or :linear
)
