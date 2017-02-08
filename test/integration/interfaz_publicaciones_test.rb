require 'test_helper'

# Cap 13.3.5
# Escrito después del código
## Ejercicio 1
class InterfazPublicacionesTest < ActionDispatch::IntegrationTest

	setup do
		@leonor = usuarios(:leonor)
	end

	test "Interfaz de publicación" do
		acceso_como(@leonor)
		get root_path
		assert_select 'div.pagination'
		# Cap 13.4.1 - Ejercicio 2
		# Test de subida de imagenes
		assert_select 'input[type="file"]'

		# Envio inválido
		## Anular Publicacion#validates :contenido, presence: true
		assert_no_difference 'Publicacion.count' do
			post publicaciones_path, params: { publicacion: { contenido: "" } }
		end
		assert_select 'div#explicacion_error'

		#Envio válido
		contenido = "Esta publicación limpia, brilla y da esplendor a la aplicacion."
		
		# Cap 13.4.1 - Ejercicio 2
		# Carga de imagenes desde test/fixtures/
		# MIME correcto? - Test verde
		#imagen = fixture_file_upload('test/fixtures/vaca.jpeg', 'image/jpeg')
		imagen = fixture_file_upload('test/fixtures/Cthulhu_constitucion.jpg', 'image/jpg')
		assert_difference 'Publicacion.count', 1 do
			post publicaciones_path, params: { publicacion: { contenido: contenido, imagen: imagen } }
		end
		assert assigns(:publicacion)
		assert assigns(:publicacion).imagen?, imagen
		
		## Anular Publicaciones#create - redirect_to root_url para fallo aquí
		assert_redirected_to root_url
		follow_redirect!
		## Anular Paginas#inicio - @publicacion:
		# 	ActionView::Template::Error: First argument in form cannot contain nil or be empty
		## Anular Paginas#inicio - @objetos_suministro:
		# 	ActionView::Template::Error: undefined method `any?' for nil:NilClass
		assert_match contenido, response.body

		# Borrar publicacion
		assert_select 'a', text: 'Borrar'
		primera_publi = @leonor.publicaciones.paginate(page: 1).first
		## Anular Publicaciones#before_action :usuario_correcto
		# 	NoMethodError: undefined method `destroy' for nil:NilClass
		## Anular Publicaciones#usuario_correcto - @publicacion
		# 	"Publicacion.count" didn't change by -1.
		assert_difference 'Publicacion.count', -1 do
			delete publicacion_path(primera_publi)
		end

		# Visita un usuario diferente (no hay enlaces de borrado)
		get usuario_path(usuarios(:lucrecia))
		## Anular app/views/publicaciones/_publicacion.html.erb - if/end 
		# 	Expected exactly 0 elements matching "a", found 2..
		assert_select 'a', text: 'Borrar', count: 0
	end

	## Ejercicio 2
	test "Cuenta de barra de publicaciones" do
		acceso_como(@leonor)
		get root_path
		assert_match "#{@leonor.publicaciones.count} publicaciones", response.body

		# Usuario sin publicaciones
		perico = usuarios(:perico)
		acceso_como(perico)
		get root_path
		assert_match "0 publicaciones", response.body
		perico.publicaciones.create!(contenido: "Una publicación")
		get root_path
		assert_match "1 publicacion", response.body
	end
end
