#!/usr/bin/env sh
curl -s https://raw.github.com/Addisonbean/Zombie-Smack-Down/master/ZSD -o /usr/local/bin/ZSD
mkdir /usr/local/bin/ZSDFiles
curl -s https://raw.github.com/Addisonbean/Zombie-Smack-Down/master/game.rb -o /usr/local/bin/ZSDFiles/game.rb
curl -s https://raw.github.com/Addisonbean/Zombie-Smack-Down/master/prefs.yaml -o /usr/local/bin/ZSDFiles/prefs.yaml

chmod +x /usr/local/bin/ZSD

echo "Success! Now enter ZSD to play Zombie Smack Down."