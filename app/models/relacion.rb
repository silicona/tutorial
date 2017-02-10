class Relacion < ApplicationRecord

# Cap 14.1
# Indices anti-redundancia creados en migracion XXXXX_create_relaciones.rb

# Cap 14.1.2
	belongs_to :seguidor, class_name: "Usuario"
	belongs_to :seguido, class_name: "Usuario"

	#Los tests de presencia no captan si las validaciones estan. Que pasa?
	validates :seguidor_id, presence: true
	validates :seguido_id, presence: true
end
