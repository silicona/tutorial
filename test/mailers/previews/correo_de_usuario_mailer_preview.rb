# Preview all emails at http://localhost:3000/rails/mailers/correo_de_usuario_mailer
class CorreoDeUsuarioMailerPreview < ActionMailer::Preview

  # Preview this email at 
  # http://localhost:3000/rails/mailers/correo_de_usuario_mailer/activacion_usuarios
  def activacion_usuarios
  	# Adaptacion del creado por Rails: 
  	# 	correo_usuarios_mailer#activacion_usuarios(usuario) necesita un
  	#   	objeto usuario válido
  	# Se define usuario y se pasa como argumento a #activacion_usuarios
  	usuario = Usuario.first
  	# Se asigna valor a token_activacion porque los templates necesitan
  	# 	un token de activacion de usuario
  	usuario.token_activacion = Usuario.nuevo_token
  	# activacion_usuarios necesita un argumento
  	CorreoDeUsuarioMailer.activacion_usuarios(usuario)
  end

  # Preview this email at
  # http://localhost:3000/rails/mailers/correo_de_usuario_mailer/reseteo_password
  def reseteo_password
    CorreoDeUsuarioMailer.reseteo_password
  end

end
