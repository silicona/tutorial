require 'test_helper'

class CorreoDeUsuarioMailerTest < ActionMailer::TestCase

  # Adaptacion del test de Rails
  test "activacion_usuarios" do
    # Debido al objeto de activacion_usuarios(usuario)
    usuario = usuarios(:leonor)
    # Añade un token_activation al usuario de fixture
    usuario.token_activacion = Usuario.nuevo_token
    mail = CorreoDeUsuarioMailer.activacion_usuarios(usuario)

    assert_equal "Activación de usuario", mail.subject

    # Adaptacion de los mails
    assert_equal [ usuario.email ], mail.to
    assert_equal ["oidosordo@example.com"], mail.from

    assert_match usuario.nombre, mail.body.encoded
    assert_match usuario.token_activacion, mail.body.encoded
    # Este usa CGI.escape
    assert_match CGI.escape(usuario.email), mail.body.encoded
    assert_no_match usuario.email, mail.body.encoded
  end

  # Calcado al superior
  test "Reseteo password" do
    usuario = usuarios(:leonor)
    usuario.token_reseteo = Usuario.nuevo_token

    mail = CorreoDeUsuarioMailer.reseteo_password(usuario)

    assert_equal "Restablecer la contraseña", mail.subject
    assert_equal [ usuario.email ], mail.to
    assert_equal ["oidosordo@example.com"], mail.from

    assert_match usuario.token_reseteo, mail.body.encoded
    assert_match CGI.escape(usuario.email), mail.body.encoded
    assert_no_match usuario.email, mail.body.encoded
  end

end

