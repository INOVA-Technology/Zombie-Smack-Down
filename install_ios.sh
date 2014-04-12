#!/usr/bin/env bash

zsd_path="$HOME/.zsd"
mkdir -p "$zsd_path" > /dev/null
mkdir -p "$zsd_path/require" > /dev/null

curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/zsd -o "$zsd_path/zsd"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/colors.rb -o "$zsd_path/require/colors.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/combo.rb -o "$zsd_path/require/combo.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/other.rb -o "$zsd_path/require/other.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/player.rb -o "$zsd_path/require/player.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/zombie.rb -o "$zsd_path/require/zombie.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/player.yml -o "$zsd_path/require/player.yml"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/scores.yml -o "$zsd_path/scores.yml"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/update.sh -o "$zsd_path/update.sh"

chmod +x "$zsd_path/zsd"
chmod +x "$zsd_path/update.sh"



if ! cat ~/.bash_profile | grep -q "\$HOME/.zsd" ; then
	echo 'export PATH="$HOME/.zsd:$PATH"' >> ~/.bash_profile
	source ~/.bash_profile
fi


if [[ -x "$zsd_path/zsd" ]]; then
	if cat ~/.bash_profile | grep -q "\$HOME/.zsd" ; then
		 curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/man/zsd.6 -o "/usr/share/man/man6/zsd.6"
		echo -e "\033[35mSuccess! Now enter zsd to play Zombie Smack Down. You may have to open a new window for it to work.\033[39m"
	else
		echo "Installation Failed. Didn't add correct path to \$PATH"
	fi
else
	echo "Installation failed. zsd is not executable."
fi
