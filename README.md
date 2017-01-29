# Tutorial Ruby on Rails

Se anula el archivo scaffolds.scss porque interfiere con el CSS del tutorial. Se renombra para que deje de ser efectivo y permanezca disponible.

Hay un archivo de expresiones regulares en el root, llamado Regexp.rb, desde el capitulo 6. supongo que ira creciendo.

Ya sabes: no son todas las que hay ni están todas las que son, pero bueno... De nada.

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
Test are not fully passed yet, e sem embargo si muove.
If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```

Heroku Advise:
Since I have a trouble with new heroku toolbelt, fuck off Heroku.
By now, at least.

For more information, see the
[*Ruby on Rails Tutorial* book](http://www.railstutorial.org/book).