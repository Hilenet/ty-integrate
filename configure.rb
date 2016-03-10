require 'yaml'

targets = YAML.load_file("config/targets.yml")[$dev_env]

$db = Db.new targets["db"]

# sinatra settings
configure do
  set :bind, "0.0.0.0"
end

