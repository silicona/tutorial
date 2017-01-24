require 'test_helper'

class PublicacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @publicacion = publicaciones(:one)
  end

  test "should get index" do
    get publicaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_publicacion_url
    assert_response :success
  end

  test "should create publicacion" do
    assert_difference('Publicacion.count') do
      post publicaciones_url, params: { publicacion: { contenido: @publicacion.contenido, usuario_id: @publicacion.usuario_id } }
    end

    assert_redirected_to publicacion_url(Publicacion.last)
  end

  test "should show publicacion" do
    get publicacion_url(@publicacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_publicacion_url(@publicacion)
    assert_response :success
  end

  test "should update publicacion" do
    patch publicacion_url(@publicacion), params: { publicacion: { contenido: @publicacion.contenido, usuario_id: @publicacion.usuario_id } }
    assert_redirected_to publicacion_url(@publicacion)
  end

  test "should destroy publicacion" do
    assert_difference('Publicacion.count', -1) do
      delete publicacion_url(@publicacion)
    end

    assert_redirected_to publicaciones_url
  end
end
