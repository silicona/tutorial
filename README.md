# Tutorial Ruby on Rails inspirado en Learn Enough To Be Dangerous

Bienvenidas, esta es la aplicacion de muestra del tutorial de Rails.

Si piensas usar este repositorio para aprender, yo creo que es imprescindible que lo acompañes de la lectura del tutorial de Michael Hart. Pero como tu lo veas...

Incluye (casi) todas las respuestas y problemas, además de algun bug que no ha sido detectado en el tutorial.

La aplicacion no ha sido probada en produccion por un problema local con Heroku Toolbelt. Lo demás, está ok.

Aviso de idioma:

	La aplicación de muestra se ha escrito utilizando terminos en lengua castellana. La intención, claramente, es poder distinguir los metodos de Ruby on Rails y las estructuras de comandos del framework. Sin embargo, la aplicacion mantiene el idioma por defecto, es decir, ingles. Para más informacion sobre la internacionalizacion, ver el repositorio Castellano (en proceso de subida), donde iré poniendo los avances en la materia.

	En el caso de que quieras seguir el tutorial utilizando palabras en castellano, mira el archivo config/initializers/inflections para asegurar la correcta correspondencia de los nombres de controladores, modelos y demás. Ten cuidado con las palabras en femenino, porque el idioma por defecto las pluraliza como si fueran palabras latinas de la segunda declinacion neutra, es decir: usuario => usuarios y cartum => carta.

	Para evitar estos problemas, comprueba tus nombres en la consola rails con "nombre".singularize y "nombre".pluralize.

Se anula el archivo scaffolds.scss porque interfiere con el CSS del tutorial. Se renombra para que deje de ser efectivo y permanezca disponible.

Expresiones regulares tipo en tutorial/regexp.rb, desde el capitulo 6. Ya sabes: no son todas las que hay ni están todas las que son, pero bueno... De nada.

Se ha realizado una limpieza de los scaffolders creados por el segundo capitulo, para que los pasos explicados en los capitulos subsiguientes sean claros.

Para la limpieza se ha procedido asi:

	git checkout -b 5_limpieza_6
	rake db:rollback (dos veces, para las dos tablas de usuarios y Publicaciones)
	rails destroy scaffold Usuarios (y Publicaciones despues)
	rails g controller Usuarios new (del capitulo 5) y su unico test.
	git add .
	git commit -m "tutorial limpio"
	git checkout master
	git merge 5_limpieza_6
	git push

Esta es la aplicacion completa y personalizada del
[*Tutorial Rails*](http://www.railstutorial.org/)
escrito por mi, bajo la inspiracion de [Michael Hartl](http://www.michaelhartl.com/).

## License

All source code in the [Ruby on Rails Tutorial](http://railstutorial.org/)
is available jointly under the MIT License and the Beerware License. See
[LICENSE.md](LICENSE.md) for details.

## Getting started

To get started with the app, clone the repo and then install the needed gems:

```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```

Heroku Advise:
Since I have a trouble with new heroku toolbelt, fuck off Heroku.
By now, at least.

For more information, see the
[*Ruby on Rails Tutorial* book](http://www.railstutorial.org/book).