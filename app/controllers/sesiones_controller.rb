class SesionesController < ApplicationController
  def new

    # Cap 10.2.3 Ejercicio 2
    #   Debugger en sesiones#new, cerrar sesion y visitar
    #     /usuarios/1/edit. Valores de session[:reenvio_url] y request.get?

    #debugger   ## Anulado para continuar el tutorial
  end

  def create
    # Cap 9.3 Ejercicio
    # Se pasa usuario a @usuario para comprobar que cookies contiene
    #   correctamente el token_recuerda del usuario

  	# Cap 8.1.3
  	# Obtiene el usuario del params[:sesion] desde la vista
  	# 	GET /acceder (sesiones#new), via POST /acceder (form_for
  	# 	de sesiones/new.html.erb)
  	# El usuario se obtiene invocando al Modelo Usuario por el mail
  	# 	dado en '/acceder'.
  	@usuario = Usuario.find_by( email: params[:sesion][:email].downcase)
  	
    # El usuario obtenido y authenticate, que confirma el password de
  	# 	[:session] con el guardado en usuario obtenido.
  	if @usuario && @usuario.authenticate(params[:sesion][:password])
  		
      # Da acceso al usuario y lo redirige a su pagina personal
  		# Usando ayudante "acceso_a" desde app/helpers/sesiones_helper.rb
  		acceso_a @usuario

      # Capitulo 9.1.2
      #   Metodo ayudante para recordar la sesión del usuario
      #   Definido en app/helpers/sesiones_helper.rb
      #recordar usuario   ## Anulado por 9.2 ##

      # Capitulo 9.2
      #   Gestiona el envio del checkbox :recuerda_me
      #   Viene desde views/sesiones/new.html.erb
      params[:sesion][:recuerda_me] == '1' ? recordar(@usuario) : 
                                             olvidar(@usuario)

      # Cap 10.2.3 - Reenvio amistoso
      # Provocado por usuarios#before_action :usuario_correcto
      # Método en SesionesHelper: reenvia de nuevo a la pagina deseada o
      #   vuelve a @usuario, pagina por defecto
      # Metodo que actua cuando la pagina del login es renderizada debido
      #   a un acceso no autorizado a una pagina
      redirige_de_vuelta_o @usuario
      
  		# Anulado por cap 10.2.3
      #redirect_to @usuario #equivalente a usuario_url(usuario)
  	else
  		# Crear mensaje de error
  		# Como no hay objeto de ActiveRecord que contenga los mensajes de
  		# 	error, se usa un flash de error para que acompañe el render

  		# Flash.now desparece al cursar la siguiente peticion HTTP.
  		# Es el idoneo para acompañar a un render
  		flash.now[:danger] = "El email o la contraseña no es correcto"

  		# Este flash permanece en la pagina web porque acompaña a un render
  		#flash[:danger] = "El email o la contraseña no es correcto"
	  	render 'new'
	  end
	  #debugger
  end

  def destroy
    # Método en SesionesHelper
    # cap 9.1.4 - Solucion al Bug Sutil 1
    #   añadido if ha_accedido? - Cierra sesion si hay una abierta.
    cerrar_sesion if ha_accedido?
    redirect_to root_url
  end

end
