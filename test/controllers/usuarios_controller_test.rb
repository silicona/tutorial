require 'test_helper'

class UsuariosControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get registro_url
    assert_response :success
  end

end
