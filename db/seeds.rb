# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Capitulo 10.3.2
# Uso de gema faker para crear multitud de usuarios en la base de datos

# Ejemplo de usuario en seed
Usuario.create!(
	nombre: "Ejemplismo",
	email: "example@railstutorial.org",
	password: "password",
	password_confirmation: "password",
	admin: true,
	activado: true,
	activado_en: Time.zone.now
)

Usuario.create!(
	nombre: "Silicona",
	email: "vertederonuclear@gmail.com",
	password: "password",
	password_confirmation: "password",
	activado: true,
	activado_en: Time.zone.now
)

Usuario.create!(
	nombre: "La virgen de Fátima",
	email: "railsprueba0@gmail.com",
	password: "password",
	password_confirmation: "password",
	activado: true,
	activado_en: Time.zone.now
)

Usuario.create!(
	nombre: "Oso Yogi",
	email: "railsprueba1@gmail.com",
	password: "password",
	password_confirmation: "password",
	activado: true,
	activado_en: Time.zone.now
)

# Uso de faker para crear a la Legion de Condenadas
# https://github.com/stympy/faker
# Cuidado con la customizacion de Faker
99.times do |n|
	nombre = Faker::GameOfThrones.character
	email = "faker-#{ n + 1 }@tutorialrails.com"
	password = "password"
	Usuario.create!(
		nombre: nombre,
		email: email,
		password: "password",
		password_confirmation: "password",
		activado: true,
		activado_en: Time.zone.now
	)
end

# Cap 13.2.2 - Ejemplos de publicaciones
usuarios = Usuario.order(:created_at).take(4)
50.times do
	contenido = Faker::ChuckNorris.fact 	# Todo por Chuck
	#contenido = Faker::Lorem.sentence(5)
	usuarios.each { |usuario| usuario.publicaciones.create!(contenido: contenido) }
end

# Cap 14.2.1 Muestras de siguiendo y seguidores
usuarios = Usuario.all
usuario = Usuario.first
siguiendo = usuarios[2..50]
seguidores = usuarios[3..40]

siguiendo.each { |seguido| usuario.seguir(seguido) }
seguidores.each { |seguidor| seguidor.seguir(usuario) }