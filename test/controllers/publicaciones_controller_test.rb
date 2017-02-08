require 'test_helper'

class PublicacionesControllerTest < ActionDispatch::IntegrationTest
  
  # Cap 13.3.1 - Control de acceso a las publicaciones
  setup do
  	@publicacion = publicaciones(:naranja)
  end

  test "Debería redirigir Create si no se ha accedido" do
  	assert_no_difference 'Publicacion.count' do
  		post publicaciones_path, params: { publicacion: { contenido: "Lorem ipsum" } }
  	end

  	assert_redirected_to acceder_url
  end

  test "Debería redirigir Destroy si no se ha accedido" do
  	assert_no_difference 'Publicacion.count' do
  		delete publicacion_path(@publicacion)
  	end

  	assert_redirected_to acceder_url
  end

  # Cap 13.3.5
  # A no puede borrar las publis de B (posterior al código)
  test " Deberia redirigir Destroy con una publicacion erronea" do
    acceso_como(usuarios(:leonor))
    publicacion = publicaciones(:hormigas)
    assert_no_difference 'Publicacion.count' do
      delete publicacion_path(publicacion)
    end

    assert_redirected_to root_url
  end

end
