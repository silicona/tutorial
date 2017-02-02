require 'test_helper'

class IndexDeUsuariosTest < ActionDispatch::IntegrationTest
  
  def setup
    @leonor = usuarios(:leonor)

    @admin = usuarios(:leonor)
    @no_admin = usuarios(:lucrecia)
  end

  test "Index con paginación" do
    acceso_como(@leonor)
    get usuarios_path
    assert_template 'usuarios/index'
    assert_select 'div.pagination', count:2
    Usuario.paginate(page: 1).each do |usuaria|
      assert_select 'a[href=?]', usuario_path(usuaria), text: usuaria.nombre
    end
  end

  test "Index con paginacion y links de Borrar" do
    acceso_como(@admin)
    get usuarios_path
    assert_template 'usuarios/index'
    assert_select "div.pagination"

    primera_pagina = Usuario.paginate(page: 1)
    primera_pagina.each do |usuaria|
      assert_select 'a[href=?]', usuario_path(usuaria), text: usuaria.nombre
      unless usuaria == @admin
        assert_select 'a[href=?]', usuario_path(usuaria), text: 'borrar'
      end
    end

    assert_difference 'Usuario.count', -1 do
      delete usuario_path(@no_admin)
    end
  end

  test "Index como usuaria no-admin" do
    acceso_como(@no_admin)
    get usuarios_path
    assert_select 'a', text: 'borrar', count: 0
  end
end

