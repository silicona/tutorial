require 'test_helper'

class SiguiendoTest < ActionDispatch::IntegrationTest

	# Cap 14.2.3 - Test de renderizado de mostrar_seguir
	def setup
		# Cap 14.2.6 - test de siguiendo
		@lucrecia = usuarios(:lucrecia)

		@leonor = usuarios(:leonor)
		acceso_como(@leonor)
	end

	# Anular ...
	test "Página Siguiendo" do
		get siguiendo_usuario_path(@leonor)
		assert_not @leonor.siguiendo.empty?
		assert_match @leonor.siguiendo.count.to_s, response.body
		@leonor.siguiendo.each do |usuario|
			assert_select "a[href=?]", usuario_path(usuario)
		end
	end

	test "Página Seguidores" do
		get seguidores_usuario_path(@leonor)
		assert_not @leonor.seguidores.empty?
		assert_match @leonor.seguidores.count.to_s, response.body
		@leonor.seguidores.each do |usuario|
			assert_select "a[href=?]", usuario_path(usuario)
		end
	end

	# Cap 14.2.6
	test " Debería seguir a un usuario de forma normal" do
		assert_difference '@leonor.siguiendo.count', 1 do
			# Error - ActionController::UnknownFormat: ActionController::UnknownFormat
			post relaciones_path, params: { seguido_id: @lucrecia.id }
		end
	end

	test "Deberia seguir a un usuario con Ajax" do
		assert_difference '@leonor.siguiendo.count', 1 do
			# 	Mismo error
			# 	Comentario XHR al final
			post relaciones_path, xhr: true, params: { seguido_id: @lucrecia.id }
		end
	end

	test "Debería dejar de seguir de forma normal" do
		@leonor.seguir(@lucrecia)
		relacion = @leonor.relaciones_activas.find_by(seguido_id: @lucrecia.id)
		assert_difference '@leonor.siguiendo.count', -1 do
			delete relacion_path(relacion)
		end
	end

	test "Debería dejar de seguir con Ajax" do
		@leonor.seguir(@lucrecia)
		relacion = @leonor.relaciones_activas.find_by(seguido_id: @lucrecia.id)
		assert_difference '@leonor.siguiendo.count', -1 do
			delete relacion_path(relacion), xhr: true
		end
	end

	#Cap 14.3.3 - ejercicio
	test "Suministro en pagina Inicio" do
		get root_path
		@leonor.suministrar.paginate(page: 1).each do |publicacion|
			assert_match CGI.escapeHTML(publicacion.contenido), response.body
		end
	end
end

## Comentario XHR:
# 	Anular solamente formato.js redirige por defecto al formato.html
# 	Hay que anular los dos formatos
# 	Borrar xhr: true convierte el assert en una test de fomrato.html

## Mensaje para bobas como yo
# Escribir correctamente:
# 	post relaciones_path, params:
# 	delete relacion_path()

# De lo contrario:
# 	ActionController::UrlGenerationError: No route matches {:action=>"destroy", :controller=>"relaciones"}
# 	ActionController::RoutingError: No route matches [DELETE] "/relaciones.519472320"
