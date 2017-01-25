require 'test_helper'

class PaginasEstaticasControllerTest < ActionDispatch::IntegrationTest
  test "should get inicio" do
    get paginas_estaticas_inicio_url
    assert_response :success
  end

  test "should get ayuda" do
    get paginas_estaticas_ayuda_url
    assert_response :success
  end

end
