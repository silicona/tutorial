# Tutorial Ruby on Rails

This is the fully application for
[*Ruby on Rails Tutorial:
Learn Web Development with Rails*](http://www.railstutorial.org/)
by [Michael Hartl](http://www.michaelhartl.com/).

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