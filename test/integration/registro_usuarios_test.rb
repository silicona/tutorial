require 'test_helper'

class RegistroUsuariosTest < ActionDispatch::IntegrationTest

	setup do
		@usuario_valido = {
			nombre: "Lilith la Oscura",
			email: "email@valido.com",
			password: "password",
			password_confirmation: "password"
		}

		@herodes = { 
			nombre: "Herodes",
			email: "usuario@invalido",
			password: "password",
			password_confirmation: "password"
		}

		@usuario = { 
			nombre: "",
			email: "",
			password: "",
			password_confirmation: ""
		}
	end

  test "Deberia ver un formulario para registrarme" do
  	get registro_path
  	assert_select "form", true, "Deberia ver el formulario de registro"
  end

	test "No deberia registrarse @foo" do
		# get no es necesario para el test, pero ayuda a visualizar
		get registro_path
		assert_no_difference 'Usuario.count' do
			# Accion del boton de Registrate YA!
			post usuarios_path, params: { usuario: { nombre: "",
																							 email: "usuario@invalido",
																							 password: "foo",
																							 password_confirmation: "bar"
																						}
																					}
		end
		# Confirma la redireccion a la vista new tras el error
		assert_template 'usuarios/new'

	end

	test "Los mensaje de error deberian ser rojos" do
		post usuarios_path, params: { usuario: @usuario } 

	  assert_template 'usuarios/new'
	  assert_select "div#explicacion_error"
	  assert_select "div#explicacion_error>ul>li#errores"
    assert_select 'div.field_with_errors'
	  #css_select("div#explicacion_error"), "color: #FF0000"
	  #assert_select "div#explicacion_error", 'color: red'
	end
	
	test "Deberia haber solo un error" do
		post usuarios_path, params: { usuario: @herodes }

		assert_select "ul#mensajes li:only-child"
		assert_select "li#errores", 1
	end

	test "Los errores de @usuario deberian ser estos" do
		post usuarios_path, params: { usuario: @usuario }

		assert_select "div" do
			assert_select "ul#mensajes>li", 1..7
		end
		assert_select "ul#mensajes li", count: 7
		assert_select "li#errores", 1..10

		assert_select "ul#mensajes li", text: "Nombre can't be blank"
		assert_select "ul#mensajes li", "Email is invalid"
		assert_select "ul#mensajes li", "Email can't be blank"

		assert_select "ul#mensajes li", text: "Password can't be blank"
		assert_select "ul#mensajes li", text: "Password is too short (minimum is 5 characters)"
		assert_select "ul#mensajes li", text: "Password is invalid"
    
	end

	test "La ruta de new GET y create POST deberia ser la misma" do
		get registro_path
		
		post registro_path, params: { usuario: @usuario }
		assert_select 'form[action="/registro"]'
		assert_select 'form[action="/usuarios"]', false, 
			"No deberia tener el form de /usuarios"
	end

	test "@usuario_valido deberia ser válido" do
		# Para este test, se necesita que la ruta a usuarios#show (resources
		# :usuarios) y su vista show.html.erb funcionen bien

		get registro_path
		# Al contrario, assert_difference necesita un segundo argumento para
		# 	reflejar el cambio en Usuario.count
		assert_difference 'Usuario.count', 1 do
			post usuarios_path, params: { usuario: @usuario_valido }
		end
		# Follow se encarga  de seguir el redireccionamiento a GET usuarios/1
		follow_redirect!
		# Confirma que se renderiza la vista del usuario (show)
		assert_template 'usuarios/show'

	end

	test "La pagina de la usuaria deberia mostrar esto" do
		post registro_path, params: { usuario: @usuario_valido }
		follow_redirect!
		assert_response 200, usuario_url(@usuario_valido)

		assert_not flash.empty?
		assert flash.keys, [:success, :exito]

		# Los test también funcionan con content_tag
		assert flash.key?(:success)
		assert flash[:success] = "Bienvenida a nuestra aplicación"
		assert_select "div.alert.alert-success", "Bienvenida a nuestra aplicación"

		assert flash.key?(:exito)
		assert flash[:exito] = "Tu usuaria se ha guardado correctamente"
		assert_select "div.alert.alert-exito", "Tu usuaria se ha guardado correctamente"
    assert flash[:warning] = "Bienvenida a nuestra aplicación"



	end
end

# assert_no_diference compara dos argumentos. Al ser un bloque con 
# 	post usuarios_path y el params: :usuario esperado para el registro,
# 	la comparación de Usuario.count se hace entre antes y después de
# 	ejecutar el post. Al ser erroneo, Usuario.count no cambiará.
# 	Comprueba los usuarios de Usuario con Usuario.count en la consola.
	# Equivalente:
	# 	cuenta_antes = Usuario.count
	# 	post usuarios_path...
	# 	cuenta_despues = Usuario.count
	# 	assert_equal cuenta_antes, cuenta_despues