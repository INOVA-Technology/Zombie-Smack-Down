#!/usr/bin/env sh
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/ZSD -o /usr/local/bin/ZSD
mkdir -p /usr/local/bin/ZSDFiles
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/ZSDFiles/game.rb -o /usr/local/bin/ZSDFiles/game.rb
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/ZSDFiles/prefs.yaml -o /usr/local/bin/ZSDFiles/prefs.yaml

chmod +x /usr/local/bin/ZSD
chmod +x /usr/local/bin/ZSDFiles/game.rb

echo "Success! Now enter ZSD to play Zombie Smack Down."
