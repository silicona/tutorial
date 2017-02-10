class UsuariosController < ApplicationController

  # Capitulo 10.2 - Autorizacion para edit y update
  # Cap 10.4.3 - Se añade :destroy a :usuario_accedido
  #   Solución simple de test/controllers/usuario_controller_test.rb
  #     test "Redirige Destroy si no hay no acceso"
  # Cap 13.3.1 - Método usuario_accedido en Helpers/application_helper.rb
  # Cap 14.2.3 - Añadido a usuario_accedido [:siguiendo, :seguidores] 
  before_action :usuario_accedido, only: [:index, :edit, 
                                          :update, :destroy,
                                          :siguiendo, :seguidores]
  before_action :usuario_correcto, only: [:edit, :update]
  before_action :usuario_admin, only: :destroy

  # Capitulo 10.3 - Mostrar todas las usuarias
  def index

    #Cap 11.3.3 - Index de usuarios activados
    @usuarios = Usuario.where(activado: true).paginate(page: params[:page])

    # Cap 10.3.3 - Paginacion
    #@usuarios = Usuario.paginate(page: params[:page])
    # Anulado por 10.3.3
    #@usuarios = Usuario.all
  end

	# Capitulo 7 - comienzo de REST
	def show
		@usuario = Usuario.find(params[:id])

    # Cap 13.2.1
    @publicaciones = @usuario.publicaciones.paginate(page: params[:page])

    # Cap 11.3.3 - Usuarios no activados
		redirect_to root_url and return unless :activacion

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

      # Cap 11.2.4 - Creacion con activacion de usuario
      # Metodo enviar_email_activacion en modelo Usuario.rb
      @usuario.enviar_email_activacion
      flash[:info] = "Por favor, comprueba tu email para activar tu cuenta."
      redirect_to root_url

    # Todo anulado por Cap 11.2.4
      # Cap 8.2.5 - Acceder al registrarse
      # Test en test/integration/registro_usuarios_test.rb:
      #   test "@usuario_valido deberia ser válido"
      # Ayudante acceso_a en app/helpers/sesiones_helper.rb
      # Metodo de test esta_identificado? en test/test_helpers.rb
      #acceso_a @usuario

      # Cap 7.3
      # flash tiene varios tipos de mensajes. Envia su contenido a
      #   la siguiente peticion HTML
      #flash[:success] = "Bienvenida a nuestra aplicación"
      #flash[:exito] = "Tu usuaria se ha guardado correctamente"
      #flash[:warning] = "Bienvenida a nuestra aplicación"

      #redirect_to @usuario #equivalente a GET usuario_path(@usuario)
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

  # Cap 10.1
  def edit
    @usuario = Usuario.find(params[:id])
  end

  def update
    @usuario = Usuario.find(params[:id])

    # Uso de la Whitelist
    if @usuario.update_attributes(parametros_de_usuario)
      # Hacer la salida para el buen guardado de datos
      flash[:success] = "Perfíl actualizado"
      redirect_to @usuario
    else
      # Los mensajes de error vienen de las validaciones de Usuario.rb
      render 'edit'
    end
  end

  def destroy
    Usuario.find(params[:id]).destroy
    flash[:success] = "Usuario eliminado"
    redirect_to usuarios_url
  end

  # Cap 14.2.3 - Meodos para las páginas de siguiendo y seguidores
  # Renderizado en: app/views/usuarios/mostrar_seguir.html.erb
  def siguiendo
    @titulo = "Siguiendo"
    @usuario = Usuario.find(params[:id])
    @usuarios = @usuario.siguiendo.paginate(page: params[:page])
    render 'mostrar_seguir'
  end

  def seguidores
    @titulo = "Seguidores"
    @usuario = Usuario.find(params[:id])
    @usuarios = @usuario.seguidores.paginate(page: params[:page])
    render 'mostrar_seguir'
  end
  # Fin 14.2.3

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

    ## Filtros Before_action

    # Cap 10.2.1 - Filtro contra anónimos
    # Confirma que un usuario ha accedido
    # def usuario_accedido  ### logged_in_user ###
    # Cap 13.3.1 - Metodo en helpers/application_helper.rb
    # ¿Porque es mala idea dejarlo?¿Solo factorizacion?


    # Cap 10.2.2 - Filtro contra otro usuario
    def usuario_correcto
      @usuario = Usuario.find(params[:id])
      #flash[:danger] = "Esa página no es tuya, bribona" ## Y esto?
      # metodo usuario_actual? en SesionesHelper
      redirect_to(root_url) unless usuario_actual?(@usuario)
    end

    # Confirma una usuaria administradora
    def usuario_admin
      
      redirect_to(root_url) unless usuario_actual.admin?

      # Solucion derivada a test "Redirige Destroy si no hay no acceso - Solucion simple"
      #   en test/controllers/usuarios_controller_test.rb
      #redirect_to(root_url) unless usuario_actual.try(:admin?)
    end

end
