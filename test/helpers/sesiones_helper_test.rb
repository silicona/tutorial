# Capitulo 9.3.2
# Para el método usuario_actual de SesionesHelper
# Se realiza porque el ayudante acceso_como establece automaticamente
# 	session[:usuario_id].
# 	El metodo recuerda no lo hace, con lo que se puede hacer el bypass.
require 'test_helper'

## Cuidadito con las correspondencias de nombres:
# 		SesionesHelper -> SesionesHelperTest
class SesionesHelperTest < ActionView::TestCase

	def setup
		# Paso 1: Definir variable con las fixtures
		@usuario = usuarios(:leonor)
		# Paso 2: el metodo recordar recuerda al usaurio dado
		recordar(@usuario)
	end

	test "usuario_actual devuelve el usuario correcto cuando session es nil" do
		# Paso 3: Verificar @usuario = usuario_actual
		# 									usuario_actual = @usuario
		# assert_equal <esperado>, <actual> - Escritura convencional
		assert_equal @usuario, usuario_actual
		assert ha_accedido?
	end

	test "usuario_actual devuelve nil cuando recuerda hace la digestión erroneo" do
		# Comprobacion de modelo Usuario#autentificado?(token_recuerda)
		@usuario.update_attribute(:recuerda_digest, Usuario.digestion(Usuario.nuevo_token))
		assert_nil usuario_actual
	end
end