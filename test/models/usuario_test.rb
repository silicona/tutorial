require 'test_helper'

class UsuarioTest < ActiveSupport::TestCase

	# Capitulo 6.2 Validaciones
	# Antes de escribir las validaciones en el modelo,
	# hacemos un test de un objeto valido.

	#Es necesario inicializar un objeto para los test del modelo

	# Capitulo 9.1.4 - Bug Sutil 2
	# Si se cierra correctamente en un navegador pero no en el segundo,
	# 	al volver a activar el segundo, da error.
	# Test "autentificar? deberia dar false"
	# 	Solucion: En método autentificar? del modelo Usuario.rb

	def setup
		@leonor = Usuario.new(
			nombre: "Leonor de Aquitania", 
			email: "entorrada@jotasto.es",
			password: 'password',
			password_confirmation: 'password',
		)
		@michael = Usuario.new(
			nombre: "Michael Caine", 
			email: "nohasleido@eltutorial.com",
		)

		# Para test de mail bien escrito 
		@malmail = Usuario.new(
			nombre: "Michael Caine", 
			email: "nohasleido@eltutorial?.com",
		)

	end

	test "Leonor debería ser una usuaria valida" do
		assert @leonor.valid?
	end

	# Test de presence: true (hecho antes que la validacion)
	# El test se hace con el método blank, más amplio que empty
	test "La usuaria deberia tener un nombre" do
		@leonor.nombre = "   " 	# por blank, da igual "" que "   "
		assert_not @leonor.valid?
	end

	test "La usuaria deberia tener un mail" do
		@leonor.email = "   " 	# por blank, da igual "" que "   "
		assert_not @leonor.valid?
	end

	# Test de validacion de longitud
	test "El nombre no debe tener mas de 20 caracteres" do
		#@leonor.nombre = "Leonor de Aquitania y Castilla la Vieja"
		@leonor.nombre = "a" * 30
		assert_not @leonor.valid?
	end

	test "El mail no deberia ser muy largo" do
		@leonor.email = "a" * 40 +"@ejemplo.com"
		assert_not @leonor.valid?
	end

	# test de formato de mail con las dos RegExp en app/models/usuario.rb
	test "El mail debería estar bien escrito" do
		#assert_match(/[a-z_]{6,15}@[a-z]{2,15}\.[a-z]{2,3}/, @leonor.email)

		assert_match(
			/\A[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})\z/i,
			@leonor.email
		)
		assert_no_match(/[a-z_]{6,15}@[a-z]{2,15}\.[a-z]{2,3}/, 
			@malmail.email)
	end

	# test de mail de tutorial de RegExp
	test "La validacion del mail deberia aceptar direcciones validas" do
		direcciones_validas = %w[
			usuario@ejemplo.com
			primero@ultimo.net
			usu_ario@miemail.com
			_UARIO@foo.COM
			A_US-UARIO@foo.org.com
			alice.foo@bar.gz
		]
		direcciones_validas.each do |direccion_valida|
			@leonor.email = direccion_valida
			assert @leonor.valid?, 
				"#{direccion_valida.inspect} deberia ser valida"
		end
	end

	test "La validacion no deberia aceptar direcciones invalidas" do
		direcciones_no_validas = %w[
			usu,a@ejemplo.com
			USUARIO@foo.CO1
			A_US-UARIO@foo..bar.org
			@ultimo.net 
			alice+foo@bar.gzgf
		]
		direcciones_no_validas.each do |direccion_no_valida|
			@leonor.email = direccion_no_valida
			assert_not @leonor.valid?, 
				"#{direccion_no_valida.inspect} no deberia ser valida"
		end
	end

	# Test de :uniqueness
	# Rojo hasta que se ponga la validacion en app/models/usuario.rb
	# 	validates :email, uniqueness: true
	test "El email deberia ser único" do
		# Se crea un usuario clonando (duplicando) a Leonor
		usuaria_clon = @leonor.dup
		# El sufijo i de la RegExp la hace "case-insensitive", esto es, mayusculas y minusculas por igual
		# a y A son iguales para la RegExp pero hacen registros distintos
		usuaria_clon.email = @leonor.email.upcase
		# Guardamos a Leonor para que su email este en la DB de test
		@leonor.save
		# comprobamos la validez del email del usuaria_clon
		assert_not usuaria_clon.valid?
	end

	# test de before_save
	# Prevencion contra adaptadores de DB case_sensitive
	test "El email deberia ser guardado en minúsculas" do
    email_MAY_min = "Foo@ExAMPle.CoM"
    @leonor.email = email_MAY_min
    @leonor.save
    assert_equal email_MAY_min.downcase, @leonor.reload.email
  end

  # Test de has_secure_password
  test "Una usuaria deberia tener contraseña" do
  	# El usuario es valido si tiene password y confirm_password
  	assert @leonor.valid?

  	assert_not @michael.valid?
  end

  # Este test no deberia salir bien
  # continua así para dar verde, por ahora
  test "una usuaria deberia confirmar la contraseña" do
  	@michael.password = 'password'
  	@michael.password_confirmation = ''
  	assert_not @michael.valid?
  end  

  test "Una usuaria deberia confirmar bien su contraseña" do
  	@michael.password = 'password'
  	@michael.password_confirmation = 'classdfgh'
  	assert_not @michael.valid?
  end

  # Test de tutorial de has_secure_password
  test "La contraseña deberia estar presente (no blank)" do
  	@michael.password = @michael.password_confirmation = "    "
  	assert_not @michael.valid?
  end

	test "La contraseña deberia tener una longitud mínima" do
		@michael.password = @michael.password_confirmation = "pass"
		assert_not @michael.valid?
	end

	# Autentificar? debería ser false para un usuario con digest nil
	test "autentificar? deberia ser false" do
		# Da error ya que BCrypt::Password.new(nil) levanta excepción
		# 	BCrypt::Errors::InvalidHash: invalid hash
		assert_not @leonor.autentificado?(:recuerda, '')
	end

end

	


# # Expresiones regulares - ejemplos

# # Fecha y hora de Time.now
# puts 'Time.now OK' if 
# 	/(\d{2,4}\-\d{1,2}\-\d{1,2})\s(\d{2}\:\d{2}\:\d{2})\s([\+\-]\d{4})/ =~ 
# 	Time.now.to_s

# # Fecha dia/mes/año - 00/00/0000 o 0/0/00
# puts 'Fecha OK' if /\d{1,2}\/\d{1,2}\/\d{2,4}/ =~ "12/12/1984"

# # Nombre de Usuario - letras minusculas, _, -, de 6 a 13
# puts 'Ok' if /[a-z_-]{6,13}/ =~ 'nombre_de_usuario'

# # correo electronico
# puts 'Email OK' if /[a-z_]{6,15}@[a-z]{2,15}\.[a-z]{2,3}/ =~
# 	"esteesmimail@dominio.net"

# # Restriccion de dominios de email
# puts 'Email restringido OK' if 
# 	/[a-z_]{6,15}@(yahoo|gmail|hotmail)\.(com|es)/ =~ "miemailesok@gmail.com"

# # Mostrar un formato de numero de telefono
# ejemplo = /(\d{3})\s(\d{6})/.match("mi telefono es 666 123456")
# puts ejemplo

# # Obtener los grupos de captura por nombre
# cadena = /(?<prefijo>\d{3})\s(?<numero>\d{6})/.match("mi telefono es 666 123456")
# 	puts cadena[:prefijo] + cadena[:numero]
# 	puts cadena.names.join(', ')
# 	puts cadena.captures

# # La Reg Exp valida el string
# puts 'String OK' if /(\d{3})\s(\d{6})/ =~ "mi telefono es 666 123456"

# Expresion de validacion de mails del tutorial
# Expression																		Meaning
# /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 					full regex
# / 																						start of regex
# \A 																						match start of a string
# [\w+\-.]+ 																		at least one word character, plus, hyphen, or dot
# @																							literal “at sign”
# [a-z\d\-.]+ 																	at least one letter, digit, hyphen, or dot
# \. 																						literal dot
# [a-z]+ 																				at least one letter
# \z 																						match end of a string
# / 																						end of regex
# i 																						case-insensitive
