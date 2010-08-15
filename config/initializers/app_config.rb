require 'app_config'

# monkey patch required by the bowels of app_config
class Pathname
  def empty?
    to_s.empty?
  end
end

# split environment overrides out into their own files to keep passwords from being checked into git
base_cfg = ::File.join(Rails.root, 'config', 'app_config.yml')
env_cfg = ::File.join(Rails.root, 'config', 'environments', "#{Rails.env}.yml")
::AppConfig = ApplicationConfiguration.new(base_cfg, env_cfg)
