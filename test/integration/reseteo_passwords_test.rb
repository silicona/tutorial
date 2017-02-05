require 'test_helper'

# Cap 12.3.3
class ReseteoPasswordsTest < ActionDispatch::IntegrationTest

	def setup
		ActionMailer::Base.deliveries.clear
		@usuario = usuarios(:leonor)
	end

	# test "reseteo_passwords"
	test " Restablecer contraseña" do
		get new_reseteo_password_path
		assert_template 'reseteo_passwords/new'

		# Email inválido
		post reseteo_passwords_path, 
				 params: { reseteo_password: { email: ""}}
		assert_not flash.empty?
		assert_template 'reseteo_passwords/new'

		# Email válido
		post reseteo_passwords_path, 
				 params: { reseteo_password: { email: @usuario.email }}
		assert_not_equal @usuario.reseteo_digest,
										 @usuario.reload.reseteo_digest
		assert_equal 1, ActionMailer::Base.deliveries.size
		assert_not flash.empty?
		assert_redirected_to root_url

		## Formulario Restablecer contraseña
		usuario = assigns(:usuario)

		## Email inválido
		get edit_reseteo_password_path(usuario.token_reseteo, email: "")
		assert_redirected_to root_url

		## Usuario inactivo
		usuario.toggle!(:activado) 	# usuario activado desde assigns
		get edit_reseteo_password_path( usuario.token_reseteo,
																	  email: usuario.email )
		assert_redirected_to root_url

		## Token erroneo, email válido
		usuario.toggle!(:activado) 	# Cambia el anterior toogle a true
		get edit_reseteo_password_path( "token erroneo", 
																		email: usuario.email )
		assert_redirected_to root_url

		## Token válido, email válido
		get edit_reseteo_password_path( usuario.token_reseteo, 
																		email: usuario.email )
		assert_template 'reseteo_passwords/edit'
			# Verifica que email pasa como oculto para llegar a params[:email]
		assert_select "input[name=email][type=hidden][value=?]", 
									usuario.email

		## Contraseña y confirmacion inválidas
		patch reseteo_password_path(usuario.token_reseteo),
					params: { email: usuario.email,
										usuario: { password: "foobar",
															 password_confirmation: "barquux" } }
		assert_select 'div#explicacion_error'

		## Contraseña vacia
		patch reseteo_password_path(usuario.token_reseteo),
					params: { email: usuario.email,
										usuario: { password: "",
															 password_confirmation: "" } }
		assert_select 'div#explicacion_error'

		## Contraseña y confirmacion válidas
		patch reseteo_password_path(usuario.token_reseteo),
					params: { email: usuario.email,
										usuario: { password: "foobar",
															 password_confirmation: "foobar" } }
		assert esta_identificada?
		assert_not flash.empty?
		assert_redirected_to usuario
	end

	# Cap 12.3.3 - Ejercicio 2
	# Comprueba la expiracion del reseteo
	# test "expired token" 
	test "token expirado" do
    get new_reseteo_password_path
    post reseteo_passwords_path,
         params: { reseteo_password: { email: @usuario.email } }

    @usuario = assigns(:usuario)
    @usuario.update_attribute(:reseteo_enviado_en, 3.hours.ago)
    patch reseteo_password_path( @usuario.token_reseteo ),
          params: { email: @usuario.email,
                    usuario: { password:              "foobar",
                            	 password_confirmation: "foobar" } }
    assert_response :redirect
    follow_redirect!
    assert_match /expirado/i, response.body
  end

end