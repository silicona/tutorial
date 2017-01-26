ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# Informe de minitest a colores
# Informe de barra de progreso, media info.
# Minitest::Reporters configurado en test/test_helper.rb
# github de la gema Minitest-reporters
# 	https://github.com/kern/minitest-reporters
require "minitest/reporters"
Minitest::Reporters.use!


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Probar los ayudantes en app/helpers/applicacion_helper.rb
  include ApplicationHelper

  # Add more helper methods to be used by all tests here...
end
