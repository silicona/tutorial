require 'test_helper'

class UsuariosControllerTest < ActionDispatch::IntegrationTest

	# Test de ingreso de usuarios en test/integration/registro_usuario.rb
	setup do
		@perla = Usuario.new(
			:id => "1", 
			nombre: "Perla del Caribe", 
			email: "caribiana@caribe.net",
			password: "password",
			password_confirmation: "password"
		)
	end

  test "should get new" do
    get registro_url
    assert_response :success
  end

end
