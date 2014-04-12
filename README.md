## Zombie Smack Down

To install:

    curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/install.sh | bash

To play just run the ZSD command!

To update your current version just run:

    ZSD -u

To see how to play just run:

    ZSD -h

Also, you can see the highscores by running:

    ZSD -s

More info in CONTROLS.md

To-do (pull requests appreciated):
* Add Windows & Linux support (Linux may work, I dont know)
* Add Linux and iOS installer
* Add web high scores
* Add randomized unknown command messages
* Everything else in todo.txt
* Convert all camel case to underscores
* Get rid of all that pInfo etc crap
* Finish tests
* Add tests for all printed output
* Have Cli#tutorial read from CONTROLS.md

# iOS Support!
Guess what. After years of waiting, popular demand has been recognized. We have finally added iOS support for Ruby 1.8.6. 


### IMPORTANT
#### Desktop
* To use Zombie Smack Down, please install ruby 1.8.7 or later.

#### iOS
* The ruby installation must be 1.8.6 because 1.9.2 is broken
* Must be logged in as root to save progress (program crashes on death)

# Adding code
* Just make sure it passes the dang tests after your changes (./tests)
