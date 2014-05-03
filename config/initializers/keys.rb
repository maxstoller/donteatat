if Rails.env == 'production'
  KEYS = {}
  KEYS[:smarty_streets][:key] = ENV['SMARTY_STREETS_KEY']
else
  KEYS = HashWithIndifferentAccess.new(YAML.load_file("#{Rails.root}/config/keys.yml"))
end
