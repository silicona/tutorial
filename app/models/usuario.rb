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

	# No deja dos puntos seguidos en el dominio
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
		length: { minimum: 5, maximum: 15 },
		format: { with: Regex_password }


	# Capitulo 8.4 - Test de log in - Acceder
	# Adaptacion de fixtures.yml para acceso_usuario_test.rb
	# El codigo necesario es:
	# 	BCrypt::Password.create(string, cost: coste_recursos)
	
	# Devuelve el hash digerido (digest) del string dado
	def Usuario.digestion(cadena)
		# Determina el segundo parametro "coste de recursos"
		coste_recursos = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :	
																														BCrypt::Engine.cost	
		# Se adapta BCrypt para que genere un digest con poco coste de recursos
		BCrypt::Password.create(cadena, cost: coste_recursos)
	end
end
