# Capitulo 10.1
require 'test_helper'

class EditarUsuariosTest < ActionDispatch::IntegrationTest

  setup do

  	@leonor = usuarios(:leonor)

  	@datos_erroneos = { 
  		nombre: "",
  		email: "foo@invalido",
  		password: "foo",
  		password_confirmation: "bar"
  	}

  	@datos_correctos = {
  		nombre: "Foo Bar",
  		email: "foo@bar.com",
  		password: "",
  		password_confirmation: ""
  	}
  end

  test "Edit erroneo" do
    # Añadido por before_action :usuario_accedido de UsuariosController
    acceso_como(@leonor)

  	get edit_usuario_path(@leonor)
  	assert_template 'usuarios/edit'
  	patch usuario_path(@leonor), params: { usuario: @datos_erroneos }
  	assert_template 'usuarios/edit'	
  	# Ejercicio
  	# Deberian ser 4, hay uno duplicado.
  	# Buscar en capitulo 7, un ejercicio del modelo usuario
  	# 	Fracaso aun- Allow_nil:true en Usuario.rb invalida las
  	assert_select "div.alert", "El registro contiene 5 errores."
  	assert_select "ul#mensajes li:first-child", "Nombre can't be blank"
		assert_select "ul#mensajes li:nth-child(2)", "Email is invalid"
		assert_select "li#errores:nth-child(5n+3)", "Password confirmation doesn't match Password"
		assert_select "li#errores:nth-child(5n+4)", "Password is too short (minimum is 5 characters)"
		assert_select "li#errores:nth-last-child(1)", "Password is invalid"
  end

  test "Edit con exito" do
  	# Añadido por before_action :usuario_accedido de UsuariosController
    acceso_como(@leonor)
    
    get edit_usuario_path(@leonor)
  	assert_template 'usuarios/edit'
  	nombre = "Foo Bar"
  	email = "foo@bar.com"
  	patch usuario_path(@leonor), params: { usuario: @datos_correctos}
  	assert_not flash.empty?
  	assert_redirected_to @leonor

  	# Recarga el usuario desde la base de datos
  	@leonor.reload

  	assert_equal nombre, @leonor.nombre
  	assert_equal email, @leonor.email
  end

  # Cap 10.2.3 - Paso libre - Friendly Forwarding
  test "Edit con exito y envio amistoso" do
    get edit_usuario_path(@leonor)
    acceso_como(@leonor)
    assert_redirected_to edit_usuario_url(@leonor)
    nombre = "Foo Bar"
    email = "foo@bar.com"
    patch usuario_path(@leonor), params: { usuario: {
      nombre: nombre,
      email: email,
      password: "",
      password_confirmation: ""
      }
    }
    assert_not flash.empty?
    assert_redirected_to @leonor
    @leonor.reload
    assert_equal nombre, @leonor.nombre
    assert_equal email, @leonor.email
    
    # Ejercicio 1: Verificar que la url de envio amistoso vuelve a
    #   la pagina por defecto en Sesioneshelper#redirige_de_vuelta_o
    assert_nil session[:reenvio_url]

    # Ejercicio 2: Debugger en sesiones#new, cerrar sesion y visitar
    #   /usuarios/1/edit
  end

end
