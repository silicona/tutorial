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
	nombre: "Usuario ejemplar",
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

# Uso de faker para crear a la Legion de Condenadas
99.times do |n|
	nombre = Faker::Name.name
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
