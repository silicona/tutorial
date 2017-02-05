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

  
  # Cap 8.2.5
  # Devuelve true si un usuario de test ha accedido.
  # Metodo paralelo a metodo acceso_a (de SesionesHelper)
  # 	Los metodos ayudantes no están disponibles en los tests, con lo
  # 	que el metodo usuario_actual (de Sesioneshelper) no se puede usar.
  # 	Se usa un nombre diferente al metodo ha_accedido? para evitar
  # 	confusion.
  # Usado en:
  #   ?
  #   reseteo_passwords_test.rb
  def esta_identificada? # is_logged_in?
  	!session[:usuario_id].nil?
  end

  # Capitulo 9.3
  # Accede como un usuario particular
  # Metodo paralelo a def acceso_a (de SesionesHelper)
  # Usados en:
  #   Test/integration/acceso_usuarios
  #     test "Acceder con recordatorio"
  #     test "Acceder sin recordatorio"
  # Primer método ayudante para el test del checkbox
  def acceso_como(usuario)
    session[:usuario_id] = usuario.id
  end

  # Segundo método ayudante para el test de checkbox
  class ActionDispatch::IntegrationTest
    #Accede con un usuario particular
    def acceso_como(usuario, password: 'password', recuerda_me: '1')
      post acceder_path params: { sesion: { email: usuario.email,
                                            password: password,
                                            recuerda_me: recuerda_me }}
    end
  end                                          
  # Add more helper methods to be used by all tests here...
end
