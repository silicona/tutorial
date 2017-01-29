class UsuariosController < ApplicationController

	# Capitulo 7 - comienzo de REST
	def show
		@usuario = Usuario.find(params[:id])
		
		# gema byebug en accion
		# En consola, permite acceder a los datos que maneja el metodo,
		# como params, o los atributos de @usuario
		# Anulado para continuar
		#debugger
	end

  def new
  	@usuario = Usuario.new

  	#debugger
  end

  def create
  	@usuario = Usuario.new(parametros_de_usuario)
  	if @usuario.save
  		# Hacer salida para registro correcto, es decir, guardado.
      # Cap 7.3
      # flash tiene varios tipos de mensajes. Envia su contenido a
      #   la siguiente peticion HTML
      flash[:success] = "Bienvenida a nuestra aplicación"
      flash[:exito] = "Tu usuaria se ha guardado correctamente"
      flash[:warning] = "Bienvenida a nuestra aplicación"

      redirect_to @usuario #equivalente a GET usuario_path(@usuario)

  	else
  		# Error en @usuario.save
  		# Los mensajes de error se añaden a @usuario
  		# 7.3 Importante - se redirecciona el fallo de @usuario.save a la
  		# 	vista de new y no al controlador para que el @usuario erroneo
  		# 	no sea sobreescrito por el @usuario de usuarios#new y puedan
  		# 	llegar los errores a la pantalla.
  		render 'new'
  	end
  end

  # Strong parameters
  # Asignacion masiva con profilaxis contra añadidos en la
  # 	URL de new.
  # Crea una Whitelist: requiere un hash y permite unos atributos
  # Se pone privado y tiene indentacion extra para remarcar los
  # 	metodos privados
  private

  	def parametros_de_usuario
  		params.require(:usuario).permit(:nombre, 
  														:email,
  														:password,
  														:password_confirmation )
  	end

end
