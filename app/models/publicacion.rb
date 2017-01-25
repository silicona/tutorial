class Publicacion < ApplicationRecord

	# Relacion entre modelos: Un usuario - Muchas publicaciones
	# Lado Publicacion:
	belongs_to :usuario

	# Limita el contenido de la publicacion a 140 caracteres
	# El contenido no puede estar vacio (mediante presence:)
	validates :contenido, length: {maximum: 140}, presence: true

	

end
