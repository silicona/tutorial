class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Capitulo 8.2
	# Inclusion del ayudante para el acceso (log in) en 
	# 	app/helpers/sesiones_helper.rb
  # Cap 13.3.1
  # Utilizado para guardar_url en método usuario_accedido
  include SesionesHelper

	# Capitulo 1 y 3 - Inicio
  def saludo
  	render html: "Hola cochino mundo"
  end
  
  # Cap 13.3.1
  private

    # Creado en Cap 10.2.1 - Filtro contra anónimos. 
    #   Movido desde usuarios_controller.rb
    # Confirma que un usuario ha accedido
    # Usado en:
    #   usuarios#before_filter :usuario_accedido
    #   publicaciones#
    def usuario_accedido  ### logged_in_user ###
      unless ha_accedido? 
        # Metodo de SesionesHelper
        guardar_url
        flash[:danger] = "Por favor, accede con tu usuaria"
        redirect_to acceder_url
      end
    end  
end
