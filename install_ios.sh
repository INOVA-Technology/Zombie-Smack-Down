#!//usr/bin/env bash

if [ ! $(which curl) ]; then
    echo "ERROR: Please install the curl command, then try again."
    exit
fi


mkdir -p "/usr/bin/zsd"
mkdir -p "/usr/bin/zsd/require"

curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/zsd -o "/usr/bin/zsd/zsd"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/colors.rb -o "/usr/bin/zsd/require/colors.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/combo.rb -o "/usr/bin/zsd/require/combo.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/other.rb -o "/usr/bin/zsd/require/other.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/player.rb -o "/usr/bin/zsd/require/player.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/zombie.rb -o "/usr/bin/zsd/require/zombie.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/player.yml -o "/usr/bin/zsd/require/player.yml"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/scores.yml -o "/usr/bin/zsd/scores.yml"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/update.sh -o "/usr/bin/zsd/update.sh"

chmod +x "/usr/bin/zsd/zsd"
chmod +x "/usr/bin/zsd/update.sh"



if ! cat ~/.bash_profile | grep -q "\$HOME/.zsd" ; then
	echo 'export PATH="/usr/bin/zsd:$PATH"' >> ~/.bash_profile
	source ~/.bash_profile
fi


if [[ -x "/usr/bin/zsd/zsd" ]]; then
	if cat ~/.bash_profile | grep -q "\$HOME/.zsd" ; then
		 curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/man/zsd.6 -o "//usr/share/man/man6/zsd.6"
		echo -e "\033[35mSuccess! Now enter zsd to play Zombie Smack Down. You may have to open a new window for it to work.\033[39m"
	else
		echo "Installation Failed. Didn't add correct path to \$PATH"
	fi
else
	echo "Installation failed. zsd is not executable."
fi
