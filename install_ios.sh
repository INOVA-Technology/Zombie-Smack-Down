#!//usr/bin/env bash

if [ ! $(which curl) ]; then
    echo "ERROR: Please install the curl command, then try again."
    exit
fi


mkdir -p "/usr/bin/zombieSD"
mkdir -p "/usr/bin/zombieSD/require"

curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/zombieSD -o "/usr/bin/zombieSD/zsd"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/colors.rb -o "/usr/bin/zombieSD/require/colors.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/combo.rb -o "/usr/bin/zombieSD/require/combo.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/other.rb -o "/usr/bin/zombieSD/require/other.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/player.rb -o "/usr/bin/zombieSD/require/player.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/zombie.rb -o "/usr/bin/zombieSD/require/zombie.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/player.yml -o "/usr/bin/zombieSD/require/player.yml"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/scores.yml -o "/usr/bin/zombieSD/scores.yml"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/update.sh -o "/usr/bin/zombieSD/update.sh"

echo "ruby /usr/bin/zombieSD/zsd" > /usr/bin/zsd

chmod +x "/usr/bin/zombieSD/zsd"
chmod +x "/usr/bin/zombieSD/update.sh"



if ! cat ~/.bash_profile | grep -q "\$HOME/.zombieSD" ; then
	echo 'export PATH="/usr/bin/zombieSD:$PATH"' >> ~/.bash_profile
	source ~/.bash_profile
fi


if [[ -x "/usr/bin/zombieSD/zombieSD" ]]; then
	if cat ~/.bash_profile | grep -q "\$HOME/.zombieSD" ; then
		 curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/man/zombieSD.6 -o "//usr/share/man/man6/zombieSD.6"
		echo -e "\033[35mSuccess! Now enter zombieSD to play Zombie Smack Down. You may have to open a new window for it to work.\033[39m"
	else
		echo "Installation Failed. Didn't add correct path to \$PATH"
	fi
else
	echo "Installation failed. zombieSD is not executable."
fi
