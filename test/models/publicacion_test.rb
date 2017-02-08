require 'test_helper'

class PublicacionTest < ActiveSupport::TestCase

	def setup
		@leonor = usuarios(:leonor)

		# Codigo erroneo - funciona por la ausencia de 
		@publicacion_codigo_erroneo = Publicacion.new(
			contenido: "Quo uosque, Catilina?",
			usuario_id: @leonor.id
		)

		# Codigo correcto al incluir has_many :publicaciones en modelo Usuario
		@publicacion = @leonor.publicaciones.build( contenido: "Quo uosque, Catilina?" )
	end

	test "Debería ser valido" do
		assert @publicacion.valid?
	end
  
  # test de salubridad - Funciona sin la validacion de usuario_id
	test "La id del usuario debería estar presente" do
		@publicacion.usuario_id = nil
		assert_not @publicacion.valid?
	end

	# test de contenido:
	test "El contenido debería estar presente" do
		@publicacion.contenido = "   "
		assert_not @publicacion.valid?
	end

	# Todo por Chuck
	test "El contenido debería ser de 300 caracteres como máximo" do
		@publicacion.contenido = "a" * 301
		assert_not @publicacion.valid?
	end

	# Cap 13.1.4
	# Test para default_scope en modelo Publicacion
	test "El orden debería ser el más reciente primero" do
		assert_equal publicaciones(:mas_reciente), Publicacion.first
	end


end
