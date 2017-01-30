# Capitulo 8.2.1 Metodo de acceso - Log in method
# Modulo incluido en app/controllers/application_controller.rb
# Metodo session - crea una cookie temporal
#		session encripta automaticamente la cookie

module SesionesHelper

	# Da acceso al usuario dado
	# Usado en:
		#	sesiones#create(inicia la sesion)
		# usuarios#create (acceder al registrarse)
	def acceso_a(usuario) 	###  log_in  ###
		session[:usuario_id] = usuario.id
	end

	# Devuelve el actual usuario accedido - logeado (si hay)
	# usuario_actual permite usar la id en las siguientes paginas web
	# 	hasta que se cierre el navegador.
	# Utilizado en views/layouts/_cabecera.html.erb
	# Su test esta en test/integration/acceso_usuario_test.rb
	def usuario_actual 		
		@usuario_actual ||= Usuario.find_by( id: session[:usuario_id])
	end

	# Capitulo 8.2.3 - Cambiando links
	# Devuelve true si el usuario esta logeado, o falso si no.
	# Utilizado en views/layouts/_cabecera.html.erb
	# Su test esta en test/integration/acceso_usuario_test.rb
	def ha_accedido? 		###  logged_in?  ###
		!usuario_actual.nil?
	end

	# Capitulo 8.3 - Cerrando sesión
	# Este método se usa en sesiones#destroy
	def cerrar_sesion
		session.delete(:usuario_id)

		# En este ejemplo, no importa lasiguiente linea, ya que hay un 
		# 	redireccionamiento al root.
		@usuario_actual = nil
	end
	
end
