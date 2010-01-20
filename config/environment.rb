require File.join(File.dirname(__FILE__), 'boot')

# Hijack rails initializer to load the bundler gem environment before loading the rails environment.
Rails::Initializer.module_eval do
  alias load_environment_without_bundler load_environment

  def load_environment
    Bundler.require_env configuration.environment
    load_environment_without_bundler
  end
end

Rails::Initializer.run do |config|
  config.time_zone = 'UTC'
end