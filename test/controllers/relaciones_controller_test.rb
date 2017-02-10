require 'test_helper'

class RelacionesControllerTest < ActionDispatch::IntegrationTest

	# Cap 14.2.4 - Boton
	# Control de acceso básico - Antes de escribir Relaciones#before_action :usuario_accedido
	# 	Error:
	# 		Expected response to be a <3XX: redirect>, but was a <204: No Content>
	test "Crear debería requerir tener un usuario accedido" do
		assert_no_difference 'Relacion.count' do
			post relaciones_path
		end
		assert_redirected_to acceder_url
	end

	test "Destruir debería requerir un usuario accedido" do
		assert_no_difference 'Relacion.count' do
			delete relacion_path(relaciones(:uno))
		end
		assert_redirected_to acceder_url
	end
end
