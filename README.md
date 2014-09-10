# What is this about?
Tired of keeping your pairing logs on paper? PairNext is an application designed to help agile teams pair more effectively. Swapping pairs around on a regular basis helps to ensure that the whole team has a knowledge of the problem domain and the codebase.

PairNext keeps track of who has paired with whom over the course of a project and then suggests new pairings endeavouring to match up team members who have paired the least.

Occasionally it is more beneficial to have two specific team members pair or perhaps keep a particular pair together when all others swap. Pair.next accommodates for this by allowing users to alter the suggested pairings by simply dragging and dropping team members around.

Curious? Just [try it](http://pairnext.herokuapp.com/)

# Installation

```bash
$ echo "SECRET_TOKEN: my_secret" >> .env # set up session secret (have to do this for shotgun to work)
$ bundle install
$ rake create && rake migrate
$ rake test # we love 'em tests
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

# Naming 

* **Pairing**: Entity in DB to store who works with whom (might be merged with Pair)
* **PairingMembership**: Entity in DB that stores that a user participates in a *Pairing*
* **Pair**: n teammembers working together on a piece of code (logic class)
* **PairingSession**: all members of a team split up into a set of Pairs (logic class)
