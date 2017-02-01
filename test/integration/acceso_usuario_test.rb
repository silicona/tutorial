require 'test_helper'

class AccesoUsuarioTest < ActionDispatch::IntegrationTest

	# Test de metodos en controlador Sesiones

	setup do
		@error = { 
			email: "",
			password: ""
		}

		# Cap 8.4
		# Usuario de test desde test/fixtures/usuarios.yml
		@usuario = usuarios(:leonor)
		
		@acceso = {
			email: @usuario.email,
			password: "password"
		}
	end

	test "Acceder sin info - Uso de flash.now" do
		# Ir a la pagina de Acceder
		get acceder_path
		# Confirmar que renderiza la vista de "sesiones#new"
		assert_template 'sesiones/new'
		# Enviar con POST /acceder el params[:sesion]
		post acceder_path, params: { sesion: @error }
		# Confirmar que renderiza de nuevo la vista de "sesiones#new"
		assert_template 'sesiones/new'	
		# Confirmar que la variable flash no está vacía
		assert_not flash.empty?
		# Ir al root
		get root_path
		# Confirmar que el flash si está vacío
		assert flash.empty?	
	end

	test "Acceder con info" do
		# Capitulo 8.4 - Pasos a comprobar
		# Obtiene GET la pagina para Acceder
		get acceder_path
		# Envia POST el params: :sesion
		post acceder_path, params: { sesion: { email: @usuario.email,
																					 password: 'password' } }
		
		# Verifica el acceso al registrarse un nuevo usuario
		# Teoria y test de registro en test/integration/registro_usuarios_test.rb
		# Metodo esta_identificada? en test/test_helper.rb
		assert esta_identificada?

		# Verifica el redireccionmiento adecuado
		assert_redirected_to @usuario
		# Sigue el redireccionamiento (visita la pagina objetivo)
		follow_redirect!
		# Verifica el template producido por redirect_to
		assert_template "usuarios/show"

		# Test de acceso al registrarse tambien en registro_usuarios_test.rb
		assert esta_identificada?

		# Verifica que desaparece el link de Acceder
		# Si falta ! en def ha_accedido?, no actualiza el usuario y los 
		# 	assert fallan porque no hay usuario definido.
		assert_select "a[href=?]", acceder_path, count: 0
		# Verifica que aparecen los link de Cerrar y Perfil
		assert_select "a[href=?]", cerrar_path
		assert_select "a[href=?]", usuario_path(@usuario)
	end

	test "acceder con info y cierre de sesión" do
		get acceder_path
		post acceder_path, params: { sesion: @acceso }
		#Verifica que el usuarioha accedido
		assert esta_identificada?
		assert_redirected_to @usuario
		follow_redirect!
		# Verifica los link de la vista de un usuario con acceso
		assert_select "a[href=?]", acceder_path, count: 0
		assert_select "a[href=?]", cerrar_path
		assert_select "a[href=?]", usuario_path(@usuario)
		# Cierra la sesión del usuario
		delete cerrar_path
		# Verifica el cierre de sesion
		assert_not esta_identificada?
		assert_redirected_to root_url
		follow_redirect!
		#Verifica los link de la vista sin usuario con acceso
		assert_select "a[href=?]", acceder_path
		assert_select "a[href=?]", cerrar_path, count: 0
		assert_select "a[href=?]", usuario_path(@usuario), count: 0		
	end

	# Test para los sutiles bugs de cap 9.1.4
	# Bug Sutil 1: Cerrar sesion en una segunda pestaña da error si
	# 	usuario_actual es nil, por cerrar sesion en la primera.
	# 	Solucion en sesiones#destroy.
	# Bug Sutil 2: En test/models/usuario_test.rb
	test "Acceder con info valida seguida de cierre" do
		get acceder_path
		post acceder_path, params: { sesion: @acceso }
		assert esta_identificada?
		assert_redirected_to @usuario
		follow_redirect!
		assert_template 'usuarios/show'
		assert_select "a[href=?]", acceder_path, count: 0
		assert_select "a[href=?]", cerrar_path
		assert_select "a[href=?]", usuario_path(@usuario)
		delete cerrar_path
		assert_not esta_identificada?
		assert_redirected_to root_url

		# Simula que un usuario cierra sesion en una ventana secundaria
		# Este delete da error si no hay usuario_actual, o nil
		# 	undefined method `olvida' for nil:NilClass
		delete cerrar_path
		follow_redirect!
		assert_select "a[href=?]", acceder_path
		assert_select "a[href=?]", cerrar_path, count: 0
		assert_select "a[href=?]", usuario_path(@usuario), count:0
	end

	# Cap 9.3 - Test de Checkbox
	test "Acceder con recordatorio" do
		acceso_como(@usuario, recuerda_me: '1')
		assert_not_empty cookies['token_recuerda']
	end

	# En sesiones#create
	#		params[:sesion][:recuerda_me] provoca error en este test, ya
	# 		que 0 y 1 (los valores de checkbox) son true.
	# 	params[:sesion][:recuerda_me] == '1' es la solucion, al 
	# 		especificar el valor del checkbox marcado para el ternario.
	test "Acceder sin recordatorio" do
		# Accede para establecer la cookie
		acceso_como(@usuario, recuerda_me: '1')
		# Accede otra vez sin recordatorio
		acceso_como(@usuario, recuerda_me: '0')
		# Verifica que la cookie se ha borrado
		assert_empty cookies['token_recuerda']
	end

	# En sesiones#create:
	# Cambio de usuario a @usuario para comprobar el token_recuerda
	# ¿Este test esta bién? - Parece...
	test "Acceder con recordatorio - Ejercicio" do
		acceso_como(@usuario, recuerda_me: '1')
		# Solucion propia
		assert assigns(:usuario).autentificar?(cookies['token_recuerda'])
		# Solucion http://stackoverflow.com/users/4909789/philip-becker
		# 	http://stackoverflow.com/questions/29797289/rails-nomethoderror-undefined-method-for-nilnilclass
		assert_equal assigns(:usuario).token_recuerda, cookies['token_recuerda']


		acceso_como(@usuario, recuerda_me: '0')
		assert_equal false, assigns(:usuario).autentificar?(cookies['token_recuerda'])
		assert_not_equal assigns(:usuario).token_recuerda, cookies['token_recuerda']

	end


end
