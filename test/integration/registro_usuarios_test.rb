require 'test_helper'

class RegistroUsuariosTest < ActionDispatch::IntegrationTest

# Cap 11.3.3 - Listing 11.33
	def setup 	# def setup == setup do
		ActionMailer::Base.deliveries.clear 

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
			password: "foo",
			password_confirmation: "bar"
		}
	end

  test "Deberia ver un formulario para registrarme" do
  	get registro_path
  	assert_select "form", true, "Deberia ver el formulario de registro"
  end

  # Retocado para identificar Listing 11.33 - Igual que antes
	test "Registro con info invalida" do
		# get no es necesario para el test, pero ayuda a visualizar
		get registro_path
		assert_no_difference 'Usuario.count' do
			# Accion del boton de Registrate YA!
			post usuarios_path, params: { 
				usuario: { 
					nombre: "",
					email: "usuario@invalido",
					password: "foo",
					password_confirmation: "bar"
				}
			}							
		end

		# Confirma la redireccion a la vista new tras el error
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
		# Serian 7, pero allow_nil: true en modelo Usuario password
		# 	inhabilita la validacion por defecto de has_secure_password
		assert_select "ul#mensajes li", count: 6
		assert_select "li#errores", 1..10

		assert_select "ul#mensajes li:first-child", text: "Nombre can't be blank"
		assert_select "ul#mensajes li:nth-child(3)", "Email is invalid"
		assert_select "ul#mensajes li:nth-child(6n+2)", "Email can't be blank"

		assert_select "ul#mensajes li:nth-child(4)", text: "Password confirmation doesn't match Password"
		assert_select "ul#mensajes li:nth-child(5)", text: "Password is too short (minimum is 5 characters)"
		assert_select "ul#mensajes li:last-child", text: "Password is invalid"
    
	end

	test "La ruta de new GET y create POST deberia ser la misma" do
		get registro_path
		
		# Test invalidado por 10.1 al crear el parcial formulario_form_for
		# Se invierte, para que no de error
		post registro_path, params: { usuario: @usuario }
		assert_select 'form[action="/usuarios"]'
		assert_select 'form[action="/registro"]', false, 
			"No deberia tener el form de /usuarios"
	end

# Retocados en cap 11.3.3
	#test "@usuario_valido deberia ser válido" do
	test "Registro con info valida y Activacion de Usuario" do
		# Para este test, se necesita que la ruta a usuarios#show (resources
		# :usuarios) y su vista show.html.erb funcionen bien

		get registro_path
		# Al contrario, assert_difference necesita un segundo argumento para
		# 	reflejar el cambio en Usuario.count
		assert_difference 'Usuario.count', 1 do
			post usuarios_path, params: { usuario: @usuario_valido }
		end
		
		# Listing 11.33
		# Comprueba que deliveries de ActionMailer tiene algo
		assert_equal 1, ActionMailer::Base.deliveries.size
		usuario = assigns(:usuario) # usuarios#create @usuario
		assert_not usuario.activado?
		# Intenta acceder antes de la activacion
		acceso_como(usuario)
		assert_not esta_identificada?
		# Token_activacion Invalido
		get edit_activacion_usuario_path("token invalido", email: usuario.email)
		assert_not esta_identificada?
		# Token_activacion válido, email erroneo
		get edit_activacion_usuario_path(usuario.token_activacion, email: 'Fracaso de email')
		assert_not esta_identificada?
		# Token_activacion valido, email tambien
		get edit_activacion_usuario_path(
			usuario.token_activacion, 
			email: usuario.email
		)
		assert usuario.reload.activado?
		# Fin 11.33

		# Follow se encarga  de seguir el redireccionamiento a GET usuarios/1
		follow_redirect!
		# Confirma que se renderiza la vista del usuario (show)
		assert_template 'usuarios/show'

		# list 8.28 - Verifica que el usuario ha accedido
		# Metodo esta_identificada? en test/test_helper.rb con teoria
		# Este metodo paralela la accion de ha_accedido? (de Sesioneshelper)
		assert esta_identificada?
	end

	test "La pagina de la usuaria deberia mostrar esto" do
		post registro_path, params: { usuario: @usuario_valido }
		usuario = assigns(:usuario)
		get edit_activacion_usuario_path(
			usuario.token_activacion, 
			email: usuario.email
			)
		follow_redirect!
		assert_response 200, usuario_url(@usuario_valido)

		assert_not flash.empty?
		assert flash.keys, :success 	#[:success, :exito]

		assert flash[:success] = "¡Cuenta activada!"
		assert_select "div.alert.alert-success", "¡Cuenta activada!"


		# Los test también funcionan con content_tag
		#assert flash.key?(:success)
		#assert flash[:success] = "Bienvenida a nuestra aplicación"
		#assert_select "div.alert.alert-success", "Bienvenida a nuestra aplicación"

		# assert flash.key?(:exito)
		# assert flash[:exito] = "Tu usuaria se ha guardado correctamente"
		# assert_select "div.alert.alert-exito", "Tu usuaria se ha guardado correctamente"
  #   assert flash[:warning] = "Bienvenida a nuestra aplicación"
	end

end

# # assert_no_diference compara dos argumentos. Al ser un bloque con 
# # 	post usuarios_path y el params: :usuario esperado para el registro,
# # 	la comparación de Usuario.count se hace entre antes y después de
# # 	ejecutar el post. Al ser erroneo, Usuario.count no cambiará.
# # 	Comprueba los usuarios de Usuario con Usuario.count en la consola.
# 	# Equivalente:
# 	# 	cuenta_antes = Usuario.count
# 	# 	post usuarios_path...
# 	# 	cuenta_despues = Usuario.count
# 	# 	assert_equal cuenta_antes, cuenta_despues