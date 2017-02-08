# Cap 13.4.3
# Apaño despues de test modificado por Ejercicio 2 en test/integration/interfaz_publicaciones_test.rb
# 	test "Interfaz de publicacion"
# Supuesto mensaje confuso en los test, despues de implementar process resize_to_limit.
# No sale mensaje

if Rails.env.test?
	CarrierWave.configure do |config|
		config.enable_processing = false
	end
end