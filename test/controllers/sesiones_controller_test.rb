require 'test_helper'

class SesionesControllerTest < ActionDispatch::IntegrationTest
  
  test "Deberia llegar a acceder" do
    # GET creado por Rails con rails g controller.
    # Anulado por tutorial desde routes.rb
    # get sesiones_new_url

    get acceder_url
    assert_response :success
  end

end
