require 'test_helper'

class RelacionTest < ActiveSupport::TestCase

	# Cap 14.1.3 - Validaciones
	def setup
		@relacion = Relacion.new(seguidor_id: usuarios(:leonor).id,
														 seguido_id: usuarios(:lucrecia).id )
	

	end

	test "Debería ser valido" do
		assert @relacion.valid?
	end

	# Test en verde antes del codigo validates
	# Funciona validates presence?? 
	# Tutorial dice que Rails 5 autovalida la presencia
	# 	Seguramente, por requerimiento de Usuario. Sin investigar
	test "Debería requerir un seguidor_id" do
		@relacion.seguidor_id = nil
		assert_not @relacion.valid?
	end

	test "Debería requerir un seguido_id" do
		@relacion.seguido_id = nil
		assert_not @relacion.valid?
	end

	test "Seguidor_id no puede ser el mismo que seguido_id" do
		@relacion.seguidor_id = @relacion_seguido_id = 1
		assert_not @relacion.valid?
	end

	test "Cero no deberia valer" do
		@relacion.seguidor_id = 0
		assert_not @relacion.valid?
	end
end
