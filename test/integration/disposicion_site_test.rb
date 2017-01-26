require 'test_helper'

class DisposicionSiteTest < ActionDispatch::IntegrationTest

	setup do
		@texto = "Esta es la página de Inicio del Tutorial Rails de Learn Enough.
  	
  	¿O pensabas que lo había hecho yo todo?"
  end

	test "enlaces_layout" do
		get root_path
		assert_template 'paginas_estaticas/inicio'
		assert_select "a[href=?]", root_path, count: 2
		assert_select "a[href=?]", acerca_path
		assert_select "a[href=?]", contacto_path
		assert_select "a[href=?]", ayuda_path
		assert_select "a[href=?]", ayuda_path, text: "Ayuda"
	end

	test "etiquetas_HTML_inicio" do
		# Probar las etiquetas que no se espera que cambien

		get root_path
		assert_select "div", count: 4
		assert_select "div", text: "foobar"
		# Clases CSS
		assert_select	"div.container"
		assert_select "ul.nav.navbar-nav.navbar-right"
		# ID CSS
		assert_select "h1#Satan"
		assert_select "h1", text: "Inicio Páginas Estáticas"
		# Atributos de <>
		assert_select "p[nombre=copyleft]"
		assert_select	"h2", text: "#{@texto}"
		# <p><a></a></p>
		assert_select "p a[href=?]", "http://www.railstutorial.org/",
		 text: "Tutoriales Learn Enough"
	end

	test "Title de Contacto" do
		# Modulo ApplicationHelper incluido en test_helper.rb
		# El test directo del ayudante en:
		# 	test/helpers/application_helper_tesst.rb

		get contacto_path
		assert_select "title", titulo_completo("Contacto")
	end

	test "Enlace a registro y titulo de registro" do
    get root_url
    assert_select "a[href=?]", registro_path, 
    	text: "Registrate YA!"
    # No se puede probar el titulo sin recurrir a get?
   	get registro_path
    assert_select "title", titulo_completo("Registrarse")
  end

end
