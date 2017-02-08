module UsuariosHelper

	# Capitulo 7.1.4 - Gravatar
	# Metotod ayudante para incluir imagenes de Gravatar en el perfil
	# (show) del usuario. Gravatar codifica en MD5
	# Metodo Digest::MD5::hexdigest - codifica con algoritmo de hash MD5

	# notese downcase, ya que MD5 es case-sensitive
	# Devuelve el Gravatar del usuario dado
	# CSS de la clase gravatar definido en estilos.scss
	# Usado en:
	# 	app/views/usuarios/_usuario.html.erb
	# 	app/views/usuarios/edit.html.erb - Cambio de gravatar
	# 	app/views/usuarios/show.html.erb
	# 	app/views/compartido/_info_usuarios.html.erb
	# 	app/views/publicaciones/_publicacion.html.erb
	def para_gravatar(usuario, medida: 80 )
		id_de_gravatar = Digest::MD5::hexdigest(usuario.email.downcase)
		
		url_de_gravatar = "Https://secure.gravatar.com/avatar/#{id_de_gravatar}?s=#{medida}"
		# Anulado por igualdad con la superior, 
		#   tras cambiar opciones = {amplitud: 80} por el actual amplitud: 80
		#dimension = opciones[:amplitud]
		#url_de_gravatar = "Https://secure.gravatar.com/avatar/#{id_de_gravatar}?s=#{dimension}"
		
		image_tag(url_de_gravatar, alt: usuario.nombre, class: "gravatar")
	end
end

# Cap 13.4.2
# 	Se cambia amplitud por medida, para mayor claridad, al implementar
# 	las validaciones de subida de imagenes, principalmente con el JV.
# Ver modelo Usuario y app/views/publicaciones/_publicacion.html.erb