class Publicacion < ApplicationRecord
  # Se subordina al modelo Usuario
  belongs_to :usuario

  # Cap 13.1.4 - Ordena las publicaciones en orden descendente (Mayor a menor)
  # Sintaxis lambda: convierte el bloque en Proc, llamado con método call
  default_scope -> { order(created_at: :desc) }

  # Cap 13.4.1 - Carrierwave asocia la imagen subida con el atributo imagen
  mount_uploader :imagen, ImagenUploader

  validates :usuario_id, presence: true

  validates :contenido, presence: true, length: { maximum: 300 } # Todo por Chuck Norris

  # Cap 13.4.2 Validacion de imagen
  # Validacion del servidor - server side
  validate :medida_de_imagen

  private

  	# Valida el tamaño de la imagen subida en la publicación
  	def medida_de_imagen
  		if imagen.size > 5.megabytes
  			errors.add(:imagen, "debería ser más pequeña que 5Mb")
  		end
  	end

end
