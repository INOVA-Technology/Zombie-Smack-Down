#!/usr/bin/env sh
sudo curl https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/ZSD -o /usr/local/bin/ZSD
sudo mkdir -p /usr/local/bin/ZSDFiles
sudo curl https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/ZSDFiles/game.rb -o /usr/local/bin/ZSDFiles/game.rb
sudo curl https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/ZSDFiles/prefs.yaml -o /usr/local/bin/ZSDFiles/prefs.yaml

chmod +x /usr/local/bin/ZSD
chmod +x /usr/local/bin/ZSDFiles/game.rb

echo "Success! Now enter ZSD to play Zombie Smack Down."
