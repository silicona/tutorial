module ApplicationHelper

	# Rails gestiona la inclusion del modulo en todas las vistas,
	# sin necesidad de que escribamos "include" en ningun lado.

	# Capitulo 4
	# Returns the full title on a per-page basis.
  # Devuelve todo el titulo en una base para cada pagina
  
  # Comentarios del metodo debido al repaso ruby del tutorial 4.2
  # Metodo def con argumento opcional
  def titulo_completo(titulo_pagina = '')
    # Asignacion de variables
    titulo_base = "Tutorial Rails"
    
    # Prueba booleana (V/F)
    if titulo_pagina.empty?
			# Retorno implicito    
      titulo_base
    else
    	# Concatenacion de strings
      titulo_pagina + " | " + titulo_base
    end
  end

  # Metodo ayudante de Santiago Ponce
  def enlace_a(nombre, url, ops = {})
    link_to(nombre, url, ops)
  end
end

