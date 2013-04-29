#!/usr/bin/env sh
sudo curl -s https://raw.github.com/Addisonbean/Zombie-Smack-Down/master/ZSD -o /usr/local/bin/ZSD
sudo mkdir /usr/local/bin/ZSDFiles
sudo curl -s https://raw.github.com/Addisonbean/Zombie-Smack-Down/master/ZSDFiles/game.rb -o /usr/local/bin/ZSDFiles/game.rb
sudo curl -s https://raw.github.com/Addisonbean/Zombie-Smack-Down/master/ZSDFiles/prefs.yaml -o /usr/local/bin/ZSDFiles/prefs.yaml

sudo chmod +x /usr/local/bin/ZSD

echo "Success! Now enter ZSD to play Zombie Smack Down."
