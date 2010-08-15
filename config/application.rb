require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "rails/test_unit/railtie"

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module MazOrg
  class Application < Rails::Application
    config.time_zone = 'Eastern Time (US & Canada)'
    config.i18n.default_locale = :en
    config.encoding = "utf-8"
  end
end
