# Cap 14.2.5 - Configuracion de degradacion gracil para JS
require File.expand_path('../boot', __FILE__)

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tutorial
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  
  	# Cap 14.2.5
    # Incluye el token de autenticidad en los formularios remotos.
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
