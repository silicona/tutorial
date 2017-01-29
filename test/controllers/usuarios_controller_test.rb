require 'test_helper'

class UsuariosControllerTest < ActionDispatch::IntegrationTest

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

  test "deberia obtener GET usuario id=1" do
  	get usuario_url(@perla)
  	assert_response :success
  end

end
