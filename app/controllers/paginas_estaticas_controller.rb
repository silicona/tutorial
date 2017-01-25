class PaginasEstaticasController < ApplicationController

	# Para emplear muchas paginas estaticas sin un controlador,
	# utilizar la gema High voltage, que provee de un path ayudante
	# para enlazar las vistas del directorio "app/views/pages/" con
	# el resto de la aplicación.
	# 	Por ejemplo: 
	# 		Con app/views/pages/about.html.erb, se puede hacer un link:
	# 			<%= link_to "Contacto", page_path ("contacto") %>

	# Github de High Voltage:
	# 	https://github.com/thoughtbot/high_voltage
	
  def inicio
  end

  def ayuda
  end

  def acerca_de_nosotras
  end

  def contacto
  end
end
