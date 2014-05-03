Geocoder.configure(
  lookup: :smarty_streets,
  api_key: Rails.application.secrets.smarty_streets_key
)
