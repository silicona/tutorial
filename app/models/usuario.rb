class Usuario < ApplicationRecord

	# Relacion entre modelos: Un usuario - Muchas publicaciones
	# Lado Usuario:
	has_many :publicaciones

	# nombre y email no pueden estar vacios
	validates :nombre, :email, presence: true

	# Validacion de los objetos asociados
	# ¿No esta bien definida?
	# validates_associated :publicaciones, :message => "Publicacion no válida", on: :create
end
