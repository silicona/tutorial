# Reusado para capitulo 5.4
# Anulaciones para comenzar desde 0

require 'test_helper'

class UsuariosControllerTest < ActionDispatch::IntegrationTest
  # setup do
  #   @usuario = usuarios(:one)
  # end

  # test "should get index" do
  #   get usuarios_url
  #   assert_response :success
  # end

  test "Debería obtener GET new" do
    get registro_path
    # Anulado por get '/registro' dee routes.rb
    #get usuarios_new_url
    assert_response :success
  end

  # test "should create usuario" do
  #   assert_difference('Usuario.count') do
  #     post usuarios_url, params: { usuario: { email: @usuario.email, nombre: @usuario.nombre } }
  #   end

  #   assert_redirected_to usuario_url(Usuario.last)
  # end

  # test "should show usuario" do
  #   get usuario_url(@usuario)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_usuario_url(@usuario)
  #   assert_response :success
  # end

  # test "should update usuario" do
  #   patch usuario_url(@usuario), params: { usuario: { email: @usuario.email, nombre: @usuario.nombre } }
  #   assert_redirected_to usuario_url(@usuario)
  # end

  # test "should destroy usuario" do
  #   assert_difference('Usuario.count', -1) do
  #     delete usuario_url(@usuario)
  #   end

  #   assert_redirected_to usuarios_url
  # end
end
