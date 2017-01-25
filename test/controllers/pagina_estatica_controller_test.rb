require 'test_helper'

class PaginaEstaticaControllerTest < ActionDispatch::IntegrationTest
  test "should get Inicio" do
    get pagina_estatica_Inicio_url
    assert_response :success
  end

  test "should get Ayuda" do
    get pagina_estatica_Ayuda_url
    assert_response :success
  end

end
