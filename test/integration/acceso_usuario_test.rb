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

end
