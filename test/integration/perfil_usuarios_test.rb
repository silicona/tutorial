require 'test_helper'

class PerfilUsuariosTest < ActionDispatch::IntegrationTest

	# Cap 13.2.3
	# Se utiliza el ayudante titulo_completo
  include ApplicationHelper

  def setup
    @leonor = usuarios(:leonor)
    @lucrecia = usuarios(:lucrecia)
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

    assert_match @leonor.seguidores.count.to_s, response.body
    assert_match @leonor.siguiendo.count.to_s, response.body

    # Cap 14.2.2 - 
    acceso_como(@leonor)
    get usuario_path(@lucrecia)
    assert_template '_formulario_seguir'
    assert_template '_seguir'

    assert_difference '@lucrecia.seguidores.count', 1 do
      post relaciones_path, params: { seguido_id: @lucrecia.id }
    end

    follow_redirect!
    assert_template 'usuarios/show'
    assert_select 'div.estadisticas'

    assert_match @lucrecia.seguidores.count.to_s, response.body
    assert_select '#seguidores', @lucrecia.seguidores.count

    assert_template '_dejar_de_seguir'
  end
end
