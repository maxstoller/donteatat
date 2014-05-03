if Rails.env == 'production'
  KEYS = {}
  KEYS[:smarty_streets] = {}
  KEYS[:smarty_streets][:key] = ENV['SMARTY_STREETS_KEY']
  KEYS[:foursquare] = {}
  KEYS[:foursquare][:client_id] = ENV['FOURSQUARE_CLIENT_ID']
  KEYS[:foursquare][:client_secret] = ENV['FOURSQUARE_CLIENT_SECRET']
  KEYS[:foursquare][:push_secret] = ENV['FOURSQUARE_PUSH_SECRET']
else
  KEYS = HashWithIndifferentAccess.new(YAML.load_file("#{Rails.root}/config/keys.yml"))
end
