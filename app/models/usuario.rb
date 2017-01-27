class Usuario < ApplicationRecord

	# Capitulo 6
	# Despues de hacer el test de test/models/usuario_test.rb

	# cap 6.2 - listing 6.32
	# Algunos adaptadores de bases de datos son case-sensitive, aunque
	# nuestra aplicacion no lo es (debido a la i de la RegExp).
	# Establecemos un before para guardar los email en minusculas en la DB:
	# before_save { self.email = email.downcase }
	# Igual
	before_save { email.downcase! }

	# Validacion del atributo del usuario / la columna nombre de la DB
	validates :nombre, presence: true, length: { maximum: 20 }

	# Tutorial
	#REGEX_VALIDACION_MAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	# No deja dos puntos seguidos enel dominio
	REGEX_VALIDACION_MAIL = /\A[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})\z/i

	validates :email, 
		presence: true, 
		length:  { maximum: 50 },
		format: {with: REGEX_VALIDACION_MAIL}, 
		#uniqueness: true
		# Debido al sufijo i de RegExp
		uniqueness: { case_sensitive: false }

	# Capitulo 6.3
	# Esta validacion se corresponde con la columna password_digest
	# 	de la tabla Usuarios, creada con una migracion
	has_secure_password

	Regex_password = /\A[a-z\d)_]{4,15}\z/

	validates :password,
		presence: true,
		length: { minimum: 6, maximum: 15 },
		format: { with: Regex_password }

	#validates :password_confirmation, presence: true

end
