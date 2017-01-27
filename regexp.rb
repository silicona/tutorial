# Expresiones regulares - ejemplos

# Fecha y hora de Time.now
puts 'Time.now OK' if 
	/(\d{2,4}\-\d{1,2}\-\d{1,2})\s(\d{2}\:\d{2}\:\d{2})\s([\+\-]\d{4})/ =~ 
	Time.now.to_s

# Fecha dia/mes/año - 00/00/0000 o 0/0/00
puts 'Fecha OK' if /\d{1,2}\/\d{1,2}\/\d{2,4}/ =~ "12/12/1984"

# Nombre de Usuario - letras minusculas, _, -, de 6 a 13
puts 'Ok' if /[a-z_-]{6,13}/ =~ 'nombre_de_usuario'

# correo electronico
puts 'Email OK' if /[a-z_]{6,15}@[a-z]{2,15}\.[a-z]{2,3}/ =~
	"esteesmimail@dominio.net"

	# Del tutorial learn Enough
	/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

# Restriccion de dominios de email
puts 'Email restringido OK' if 
	/[a-z_]{6,15}@(yahoo|gmail|hotmail)\.(com|es)/ =~ "miemailesok@gmail.com"

# Mostrar un formato de numero de telefono
ejemplo = /(\d{3})\s(\d{6})/.match("mi telefono es 666 123456")
puts ejemplo

# Obtener los grupos de captura por nombre
cadena = /(?<prefijo>\d{3})\s(?<numero>\d{6})/.match("mi telefono es 666 123456")
	puts cadena[:prefijo] + cadena[:numero]
	puts cadena.names.join(', ')
	puts cadena.captures

# La Reg Exp valida el string
puts 'String OK' if /(\d{3})\s(\d{6})/ =~ "mi telefono es 666 123456"

1. Validar una URL

	¿Quieres saber si una dirección web es válida? 
	No hay problema con esta expresión regular lo tendremos muy fácil:

  /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \?=.-]*)*\/?$/  

2. Validar un E-mail

	En muchas ocasiones necesitaremos saber si un e-mail con el que
	se trata de registrar un usuario es válido:

  /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$/  

3. Comprobar la seguridad de una contraseña

	Para aquellos que necesitáis sugerir / comprobar la fortaleza de una contraseña:

  /(?=^.{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/

	De esta forma comprobaremos:

  Contraseñas que contengan al menos una letra mayúscula.
  Contraseñas que contengan al menos una letra minúscula.
  Contraseñas que contengan al menos un número o caracter especial.
  Contraseñas cuya longitud sea como mínimo 8 caracteres.
  Contraseñas cuya longitud máxima no debe ser arbitrariamente limitada.

4. Validar un número de teléfono

	Con este snippet se validarán todos los número de teléfono pertenecientes
		a los listados en la Wikipedia:

  ^\+?\d{1,3}?[- .]?\(?(?:\d{2,3})\)?[- .]?\d\d\d[- .]?\d\d\d\d$  

5. Validar número de tarjeta de crédito

	Ahora que tan de moda está el e-commerce seguro que esto
		le vendrá bien a más de uno:

  ^((67\d{2})|(4\d{3})|(5[1-5]\d{2})|(6011))(-?\s?\d{4}){3}|(3[4,7])\ d{2}-?\s?\d{6}-?\s?\d{5}$  

6. Recoger ID de un vídeo de Youtube

	Si necesitas recoger el ID de un vídeo de Youtube en sus múltiples
		combinaciones, esta es tu expresión regular:

  /http:\/\/(?:youtu\.be\/|(?:[a-z]{2,3}\.)?youtube\.com\/watch(?:\?|#\!)v=)([\w-]{11}).*/gi  

7. Validar todas las etiquetas de imagen sin cerrar

	Ahora que prácticamente todos empleamos xHTML es interesante comprobar
	  que todas nuestras etiquetas de imagen están correctamente cerradas:

  <img([^>]+)(\s*[^\/])></img([^>  

8. Validar una dirección IP

	Si necesitas validar una dirección IP introducida por un usuario,
	  esto te será de gran ayuda:

  /^(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]).){3}([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/  

9. Validar código postal

	En muchas ocasiones necesitamos recoger en los formularios de
		alta el código postal:

  ^([1-9]{2}|[0-9][1-9]|[1-9][0-9])[0-9]{3}$  

10. Validar un nombre de usuario

	Si por ejemplo quisiésemos validar un nombre de usuario con un mínimo
	  de 4 caracteres y un máximo de 15 haríamos lo siguiente:

  /^[a-z\d_]{4,15}$/i  

	Además el nombre estaría utilizando sólo caracteres de la a-z y números.

Expresion de validacion de mails del tutorial
Expression																		Meaning
/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 					full regex
/ 																						start of regex
\A 																						match start of a string
[\w+\-.]+ 																		at least one word character, plus, hyphen, or dot
@																							literal “at sign”
[a-z\d\-.]+ 																	at least one letter, digit, hyphen, or dot
\. 																						literal dot
[a-z]+ 																				at least one letter
\z 																						match end of a string
/ 																						end of regex
i 																						case-insensitive
