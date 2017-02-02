# Capitulo 8.2.1 Metodo de acceso - Log in method
# Modulo incluido en app/controllers/application_controller.rb
# Metodo session - crea una cookie temporal
#		session encripta automaticamente la cookie

module SesionesHelper

	# Da acceso al usuario dado
	# Usado en:
		#	sesiones#create(inicia la sesion)
		# usuarios#create (acceder al registrarse)
		# def usuario_actual, más abajo
	def acceso_a(usuario) 	###  log_in  ###
		session[:usuario_id] = usuario.id
	end

	# Capitulo 9.1.2
	# Usado en sessiones#create
	# Recuerda un usuario en una sesion persistente
	# El navegador del usuario obtiene un token_recuerda válido
	def recordar(usuario) 	### remember ###
		# Método recuerda en modelo Usuario.rb
		usuario.recuerda
		# La id del usuario se empareja con el token_recuerda
		cookies.permanent.signed[:usuario_id] = usuario.id
		cookies.permanent[:token_recuerda] = usuario.token_recuerda
	end

	# Capitulo 10.2.2
	# Metodo para test
	# Devuelve true si el usuario dado es el usuario actual
	def usuario_actual?(usuario)
		usuario == usuario_actual
	end

	# Devuelve el actual usuario accedido - logeado (si hay)
	# usuario_actual (sesion temporal) permite usar la id en las 
	# 	siguientes paginas web hasta que se cierre el navegador.
	# Utilizado en views/layouts/_cabecera.html.erb
	# Su test esta en test/integration/acceso_usuario_test.rb
	## 	Modificado en 9.1.2
	##  Añadida construcción para recoger session y cookies
	def usuario_actual 	### current_user ###

	##  Version sin reduplicar session y cookies, concentrandolos en la
	## 		variable usuario_id

		# Rama sesion temporal
		if ( usuario_id = session[:usuario_id] )

			# Este usuario_actual solo conoce la sesion temporal		
			#@usuario_actual ||= Usuario.find_by( id: session[:usuario_id])
			@usuario_actual ||= Usuario.find_by( id: usuario_id )

		# Rama Recuerda - sesión permamente	
		elsif ( usuario_id = cookies.signed[:usuario_id] )
			
			# Cap 9.3.2 - Test de la rama Recuerda
			# No hay test para comprobar la factorizacion del metodo para 11
			# Raise para provocar fallo 
			#raise 		## Anulado para test en verde ##
			## Fin 9.3.2 ##

			# Variable local para trabajar en el método
			usuario = Usuario.find_by( id: usuario_id)
			
			# Método autentificado? en modelo Usuarios.rb
			## Cap 9.3.2 Ejercicio - test "usuario_actual devuelve nil cuando recuerda hace la digestión erroneo" do
			## Falla si autentificado? está comentado
			if usuario && usuario.autentificado?(cookies[:token_recuerda])
				
				# Metodo más arriba
				acceso_a usuario
				@usuario_actual = usuario
			end
		end
		## fin 9.1.2 ##
	
	end

	# Capitulo 8.2.3 - Cambiando links
	# Devuelve true si el usuario esta logeado, o falso si no.
	# Utilizado en views/layouts/_cabecera.html.erb
	# Su test esta en test/integration/acceso_usuario_test.rb
	def ha_accedido? 		###  logged_in?  ###
		!usuario_actual.nil?
	end

	# Capitulo 9.1.3 - Olvidando usuarios
	# Olvida ( termina ) una sesion persistente
	def olvidar(usuario)
		# Método olvida en Modelo Usuario.rb
		usuario.olvida
		# Borra las dos cookies
		cookies.delete(:usuario_id)
		cookies.delete(:token_recuerda)
	end

	# Capitulo 8.3 - Cerrando sesión
	# Este método se usa en sesiones#destroy
	def cerrar_sesion 	### log_out ###
		# Cap 9.1.3
		# Método más arriba
		olvidar(usuario_actual)
		# Fin 9.1.3 #
		session.delete(:usuario_id)

		# En este ejemplo, no importa la siguiente linea, ya que hay un 
		# 	redireccionamiento al root.
		@usuario_actual = nil
	end
	
	# Capitulo 10.2.3
	# Metodos para Envio Amistoso
	# Recupera la URL a la que se intentaba ir cuadno salio el error
	# Redirige a la localizacion guardada o al default. Después, borra
	# 	la session para que no redirija más a la misma pagina
	# Usado en:
	# 	sesiones#create
	def redirige_de_vuelta_o(url_por_defecto)
		redirect_to(session[:reenvio_url] || url_por_defecto)
		session.delete(:reenvio_url)
	end

	# Guarda la url a la que se intenta acceder
	# La cola if se asegura que el método no responde a otras peticiones
	# 	HTTP, comoun usuario que borre la cookie del navegador y envie un
	# 	formulario (de creación o actualización)
	# Usado en:
	#		usuarios#usuario_accedido
	def guardar_url
		session[:reenvio_url] = request.original_url if request.get?
	end
end
