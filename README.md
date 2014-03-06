# Installation

```bash
$ echo "SECRET_TOKEN: my_secret" # set up session secret (have to do this for shotgun to work)
$ bundle install
$ rake create
$ bundle exec rspec # we love 'em tests
$ rake shotgun # fire up the dev server
```
