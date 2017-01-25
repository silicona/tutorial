require 'test_helper'

# web de assertions de minitest
# http://guides.rubyonrails.org/testing.html#available-assertions

# Minitest::Reporters configurado en test/test_helper.rb
# github de la gema Minitest-reporters
# 	https://github.com/kern/minitest-reporters

class PaginasEstaticasControllerTest < ActionDispatch::IntegrationTest
  
  # Se crea setup para factorizar parte de <title>
  setup do
  	@tutorial = "Tutorial Rails"
  end

  # Test de root
  test "El root debería ir a Inicio" do
  	get '/'
  	assert_response 200, 'paginas_estaticas/inicio'
  end

	# Comprueban la peticion GET de acceso a la pagina
	# 	mediante URL:
  test "should get Inicio" do
    get paginas_estaticas_inicio_url

    # success es la representacion del codigo HTML devuelto:
    # En este caso, 200 OK
  	# 1xx Informational
  	# 2xx Success
		# 3xx Redirection
		# 4xx Client Error
		# 5xx Server Error
    assert_response :success

    # Assert para comprobar la presencia de la etiqueta HTML 
    # <title> (selector) en la pagina obtenida por GET
    # @tutorial factoriza parte de <title>
    # Se usa este assert para el proceso de refactorizacion de
    # application.html.erb y las vistas
    assert_select "title", "#{@tutorial}"
  end

  test "should get Ayuda" do
    get paginas_estaticas_ayuda_url
    assert_response :success

    # Assert de selector
    # @tutorial factoriza parte de <title>
    assert_select "title", "Ayuda | #{@tutorial}"

  end

  # test Rojo
  test "debería obtener GET Acerca de nosotras" do
  	get paginas_estaticas_acerca_de_nosotras_url
  	assert_response :success

  	# Assert de selector
  	# @tutorial factoriza parte de <title>
    assert_select "title", "Acerca de nosotras | #{@tutorial}"
  end

  test "debería obtener GET Contacto" do
  	get paginas_estaticas_contacto_url
  	assert_response :success

  	assert_select "title", "Contacto | #{@tutorial}"
  end

end
