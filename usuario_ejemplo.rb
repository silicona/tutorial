# Archivo creado por capitulo 4.5.5
# Archivo borrado al finalizar el capitulo 4.

# class Usuario

# 	# El accessor crea los metodos para leer
# 	# y escribir la variable de instancia pasada como simbolo.
# 	attr_accessor :nombre, :email

# 	# Metodo constructor de la clase, se llama al ejecutar Usuario.new
# 	# Tiene como argumento "atributos", un hash opcional.
# 	def initialize(atributos = {})
# 		@nombre = atributos[:nombre]
# 		@apellidos = atributos[:apellidos]
# 		@email = atributos[:email]
# 	end

# 	# Metodo propio que presenta los valores asignados a las 
# 	# variables de instancia con un formato de texto.
# 	def email_con_formato
# 		"#{nombre_completo} <#{email}>"
# 	end

# 	def nombre_completo
# 		"#{@nombre} #{@apellidos}"
# 	end

# 	def nombre_alfabetico
# 		"#{@apellidos}, #{nombre}"
# 	end
# end

# =begin

# Probar la creacion de un objeto en la consola Rails ($ rails c)
# 1>> require './ejemplo_usuario.rb'
# 2>> ejemplo = Usuario.new
# ...
# ó asi:
# 2>> usuario = Usuario.new(nombre: "Paco", email: "email@email.com")
# 3>> usuario.email_con_formato

# Probar metodos nombre_completo y nombre_alfabetico, pero con un
# solo apellidos. No pidais peras al geranio.
# =end
