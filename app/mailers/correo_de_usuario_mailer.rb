class CorreoDeUsuarioMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.correo_de_usuario_mailer.activacion_usuarios.subject
  #
  def activacion_usuarios(usuario)

    @usuario = usuario
    mail to: usuario.email, subject: "Activación de usuario"

    #@greeting = "Hi"
    #mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.correo_de_usuario_mailer.reseteo_password.subject
  #
  def reseteo_password

    @greeting = "Hi"
    mail to: "to@example.org"
  end
end
