class UsuariosController < ApplicationController

  # Capitulo 10.2 - Autorizacion para edit y update
  # Cap 10.4.3 - Se añade :destroy a :usuario_accedido
  #   Solución simple de test/controllers/usuario_controller_test.rb
  #     test "Redirige Destroy si no hay no acceso"
  before_action :usuario_accedido, only: [:index, :edit, :update, :destroy]
  before_action :usuario_correcto, only: [:edit, :update]
  before_action :usuario_admin, only: :destroy

  # Capitulo 10.3 - Mostrar todas las usuarias
  def index

    # Cap 10.3.3 - Paginacion
    @usuarios = Usuario.paginate(page: params[:page])
    # Anulado por 10.3.3
    #@usuarios = Usuario.all
  end

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

      # Cap 8.2.5 - Acceder al registrarse
      # Test en test/integration/registro_usuarios_test.rb:
      #   test "@usuario_valido deberia ser válido"
      # Ayudante acceso_a en app/helpers/sesiones_helper.rb
      # Metodo de test esta_identificado? en test/test_helpers.rb
      acceso_a @usuario

      # Cap 7.3
      # flash tiene varios tipos de mensajes. Envia su contenido a
      #   la siguiente peticion HTML
      flash[:success] = "Bienvenida a nuestra aplicación"
      flash[:exito] = "Tu usuaria se ha guardado correctamente"
      #flash[:warning] = "Bienvenida a nuestra aplicación"

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

    # Cap 10.2.1 - Filtro contra anónimos
    def usuario_accedido
      unless ha_accedido?
        # Metodo de SesionesHelper
        guardar_url
        flash[:danger] = "Por favor, accede con tu usuaria"
        redirect_to acceder_url
      end
    end

    # Cap 10.2.2 - Filtro contra otro usuario
    def usuario_correcto
      @usuario = Usuario.find(params[:id])
      flash[:peligro] = "Esa página no es tuya, bribona"
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
