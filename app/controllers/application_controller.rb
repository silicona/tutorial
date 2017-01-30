class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Capitulo 8.2
	# Inclusion del ayudante para el acceso (log in) en 
	# 	app/helpers/sesiones_helper.rb
	include SesionesHelper

	# Capitulo 1 y 3 - Inicio
  def saludo
  	render html: "Hola cochino mundo"
  end
  
end
