require 'test_helper'

class UsuariosControllerTest < ActionDispatch::IntegrationTest

	# Test de ingreso de usuarios en test/integration/registro_usuario.rb
	setup do
		@leonor = usuarios(:leonor)
		@lucrecia = usuarios(:lucrecia)

	end

  test "should get new" do
    get registro_url
    assert_response :success
  end

  # Cap 10.2.1
  test "Deberia redirigir edit si el usuario no ha accedido" do
  	get edit_usuario_path(@leonor)
  	assert_not flash.empty?
  	assert_redirected_to acceder_url
  end

  test "Debería redirigir Update si el usuario no ha accedido" do
  	patch usuario_path(@leonor), params: { usuario: { nombre: @leonor.nombre,
  																										email: @leonor.email } }
  	assert_not flash.empty?
  	assert_redirected_to acceder_url
  end

  # Cap 10.2.2
  test "debería redirigir Edit cuando se accede con otro usuario" do
  	acceso_como(@lucrecia)
  	get edit_usuario_path(@leonor)

    # Mal invertido - flash eliminado
    # invertido por flash en usuarios#usuario_correcto
    assert flash.empty? ## original del tutorial
    
    assert_redirected_to root_url
  end

  test "Debería redirigir Update cuando se accede con otro usuario" do
  	acceso_como(@lucrecia)
  	
  	# Simula el envio de info tras pulsar el boton de enviar
  	patch usuario_path(@leonor), params: { usuario: {nombre: @leonor.nombre,
  																									 email: @leonor.email } }
    
    # Mal invertido - flash eliminado
    # invertido por flash en usuarios#usuario_correcto
    assert flash.empty? ## original del tutorial
  	
    assert_redirected_to root_url
  end

  # Test para Cap 10.2.3 en editar_usuarios_test.rb
  # 	test "Edit con exito y envio amistoso"

  # Cap 10.3
  # Test previo para restringir Index a quien tenga acceso
  test "Debería redirigir Index cuando no se ha accedido" do
  	get usuarios_path
  	assert_redirected_to acceder_url
  end

  # Cap 10.4.1 Ejercicio
  # Test en verde... correcto?
  test "No debería permitir que el atributo admin sea editado via web" do
    acceso_como(@lucrecia)
    assert_not @lucrecia.admin?
    patch usuario_path(@lucrecia), params: { usuario: { password: "",
                                                        password_confirmation: "",
                                                        admin: true}}
    assert_not @lucrecia.admin?
  end

  # Cap 10.4.2
  # Se emite una peticion DELETE con delete
  # Caso 1: Usuarios sin acceso son redirigidas a la pagina de acceso
  ## Original da error: undefined method `admin?' for nil:NilClass
  #   Ver: http://stackoverflow.com/questions/35906040/hartl-rails-tutorial-ch9-test-should-redirect-destroy-when-not-logged-in-erro
  
  ##  Solucion simple (user7418468):
  #     Añadir :destroy a usuarios#before_action :usuario_accedido
  #     Entonces, pasa por ese metodo y redirige a acceder_url
  test "Redirige Destroy si no hay no acceso - Solucion simple" do
    assert_no_difference 'Usuario.count' do
      delete usuario_path(@leonor)
    end
    assert_redirected_to acceder_url
  end
  
  ##  Solucion derivada (bf34):
  #     Añadir usuario_actual.try(:admin) en usuarios#usuario_admin
  #     Entonces, pasa por ese método y redirige a root_url
  # test "Redirige Destroy si no hay no acceso - Solucion derivada" do
  #   assert_no_difference 'Usuario.count' do
  #     delete usuario_path(@leonor)
  #   end
  #   assert_redirected_to root_url
  # end

  # Caso 2: Usuarioas no-admin son redirigidos al Inicio
  test "Debería redirigir Destroy cuando ha accedido como no-admin" do
    acceso_como(@lucrecia)
    assert_no_difference 'Usuario.count' do
      delete usuario_path(@leonor)
    end
    assert_redirected_to root_url
  end

  # Cap 14.2.3 - Paginas de seguidores y siguiendo
  # Rutas nombradas en routes.rb
  # Error -  AbstractController::ActionNotFound: The action 'siguiendo' could not be found for UsuariosController
  test "debería redirigir Siguiendo si no hay acceso" do
    get siguiendo_usuario_path(@leonor)
    assert_redirected_to acceder_url
  end

  test "Debería redirigir Seguidores si no hay acceso" do
    get seguidores_usuario_path(@leonor)
    assert_redirected_to acceder_url
  end


end