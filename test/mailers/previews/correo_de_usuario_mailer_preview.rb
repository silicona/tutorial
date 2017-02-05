# Preview all emails at http://localhost:3000/rails/mailers/correo_de_usuario_mailer
class CorreoDeUsuarioMailerPreview < ActionMailer::Preview

  # Preview this email at 
  # http://localhost:3000/rails/mailers/correo_de_usuario_mailer/activacion_usuarios
  # Cap 11
  def activacion_usuarios
  	# Adaptacion del creado por Rails: 
  	# 	correo_usuarios_mailer#activacion_usuarios(usuario) necesita un
  	#   	objeto usuario válido
  	# Se define usuario y se pasa como argumento a Correo...Mailer#activacion_usuarios
  	usuario = Usuario.first
  	# Se asigna valor a token_activacion porque los templates necesitan
  	# 	un token de activacion de usuario
  	usuario.token_activacion = Usuario.nuevo_token
  	# activacion_usuarios necesita un argumento
  	CorreoDeUsuarioMailer.activacion_usuarios(usuario)
  end

  # Preview this email at
  # http://localhost:3000/rails/mailers/correo_de_usuario_mailer/reseteo_password
  # Rellenado en Cap 12.2
  def reseteo_password
    # como en activacion_usuarios (más arriba)
    usuario = Usuario.first
    usuario.token_reseteo = Usuario.nuevo_token

    CorreoDeUsuarioMailer.reseteo_password(usuario)
  end

end
