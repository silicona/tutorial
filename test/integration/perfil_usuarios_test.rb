require 'test_helper'

class PerfilUsuariosTest < ActionDispatch::IntegrationTest

	# Cap 13.2.3
	# Se utiliza el ayudante titulo_completo
  include ApplicationHelper

  def setup
    @leonor = usuarios(:leonor)
  end

  #test "profile display" do
  test "Vista del perfíl de usuario" do
    get usuario_path(@leonor)
    assert_template 'usuarios/show'
    assert_select 'title', titulo_completo(@leonor.nombre)
    assert_select 'h1', text: @leonor.nombre
    assert_select 'h1>img.gravatar'
    assert_match @leonor.publicaciones.count.to_s, response.body
    assert_select 'div.pagination'
    @leonor.publicaciones.paginate(page: 1).each do |publicacion|
      assert_match publicacion.contenido, response.body
    end
  end
end
