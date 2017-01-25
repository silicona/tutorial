require 'test_helper'

class PaginasEstaticasControllerTest < ActionDispatch::IntegrationTest
  test "should get Inicio" do
    get paginas_estaticas_Inicio_url
    assert_response :success
  end

  test "should get Ayuda" do
    get paginas_estaticas_Ayuda_url
    assert_response :success
  end

end
