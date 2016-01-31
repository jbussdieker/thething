require 'salt/api'

Salt::Api.configure do |config|
  config.hostname = "localhost"
  config.username = "salt_api"
  config.password = "password"
  config.use_ssl = false
end
