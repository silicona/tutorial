class SesionesController < ApplicationController
  def new
  end

  def create
  	# Cap 8.1.3
  	# Obtiene el usuario del params[:sesion] desde la vista
  	# 	GET /acceder (sesiones#new), via POST /acceder (form_for
  	# 	de sesiones/new.html.erb)
  	# El usuario se obtiene invocando al Modelo Usuario por el mail
  	# 	dado en '/acceder'.
  	usuario = Usuario.find_by( email: params[:sesion][:email].downcase)
  	# El usuario obtenido y authenticate, que confirma el password de
  	# 	[:session] con el guardado en usuario obtenido.
  	if usuario && usuario.authenticate(params[:sesion][:password])
  		# Da acceso al usuario y lo redirige a su pagina personal
  		# Usando ayudante "acceso_a" desde app/helpers/sesiones_helper.rb
  		acceso_a usuario 
  		redirect_to usuario #equivalente a usuario_url(usuario)
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
    cerrar_sesion
    redirect_to root_url
  end

end
