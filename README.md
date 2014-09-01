# Installation

```bash
$ echo "SECRET_TOKEN: my_secret" >> .env # set up session secret (have to do this for shotgun to work)
$ bundle install
$ rake create
$ bundle exec rspec # we love 'em tests
$ rake shotgun # fire up the dev server
```

# Setup with Vagrant

* Install Requirements: 
  * http://www.vagrantup.com/downloads
* `vagrant up` (spins up a virtual machine and sets up a ruby environment)
* `vagrant ssh` (logs into vagrant)
* In the VM, the project is in /vagrant
* Execute bundle install to install all the dependencies
* After that `rake migrate && rake test && rake shotgun` gives you a running app
* Port 4567 is mapped into the VM so access a running app in the VM by pointing your host-browser to http://localhost:4567
* You can continue editing project files from the host, it's automatically synced into the VM
* The VM blocks port 4567 so make sure you don't have anything else binding to that port if you get errors