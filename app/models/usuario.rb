class Usuario < ApplicationRecord

	# Capitulo 9
	# Accessor para emular a has_secure_password
	# Utilizado en metodo recuerda, más abajo
	attr_accessor :token_recuerda

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
	validates :nombre, presence: true, length: { maximum: 25 }

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
		format: { with: Regex_password },
		# Permite que editar el perfil no obligue a cambiar la password
		allow_nil: true

	# Capitulo 8.4 - Test de log in - Acceder
	# Adaptacion de fixtures.yml para acceso_usuario_test.rb
	# El codigo necesario es:
	# 	BCrypt::Password.create(string, cost: coste_recursos)
	
	# Devuelve el hash digerido (digest) del string dado
	#def Usuario.digestion(cadena) ##	Anulado por Listado 9.4 ##
	#def self.digestion(cadena) ## Anulado por Listado 9.5 ##
	class << self 	### Listado 9.5 ###
		def digestion(cadena)
			# Determina el segundo parametro "coste de recursos"
			coste_recursos = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :	
																															BCrypt::Engine.cost	
			# Se adapta BCrypt para que genere un digest con poco coste
			# 	de recursos.
			BCrypt::Password.create(cadena, cost: coste_recursos)
		end

		# Capitulo 9.1 - Sesion permanente
		# Creamos el token con nuevo_token
		# Asociamos el digest

		# Devuelve un token aleatorio, codificado en base64
		#def Usuario.nuevo_token 		## Anulado por Listado 9.4 ##
		#def self.nuevo_token 	 ## Anulado por Listado 9.5 ##
		def nuevo_token
			SecureRandom.urlsafe_base64
		end
	end

	# Asocia el token_recuerda con el usuario y lo guarda en la db
	# Recuerda a un usuario en la base de datos para usarlo en sesiones
	# 	persistentes.
	def recuerda
		# Crea el token_recuerda
		# Sin self, token_recuerda solo sería local
		self.token_recuerda = Usuario.nuevo_token
		# Asocia el token_recuerda con :recuerda_digest 
		update_attribute( :recuerda_digest, Usuario.digestion(token_recuerda) )
	end

	# Capitulo 9.1.2 - Acceder con recuerda
	# Metodo que hace la función de authenticate de has_secure_password
	# Metodo que desencripta la id de la cookie y la compara con :recuerda_digest
	# Devuelve true si el token coincide con el digest
	# Usado en SesionesHelper#usuario_actual
	def autentificado?(token_recuerda)
		# Cap 9.1.4 - Bug Sutil 2 (desde test de modelo usuario)
		# 	Solucion: Devuelve false si el digest es nil
		return false if recuerda_digest.nil?
		
		# token_recuerda es una variable local del método y no el accessor
		## Nota: token_recuerda está Hashed, no encriptado
		# el atributo recuerda_digest es el mismo de self.recuerda_digest
		BCrypt::Password.new(recuerda_digest).is_password?(token_recuerda)
	end

	# Cap 9.1.3 - Olvidando usuarios
	# Olvida a un usuario, al contrario que recuerda
	# Usado en SesionesHelper#olvidar
	def olvida
		update_attribute(:recuerda_digest, nil)
	end

end
