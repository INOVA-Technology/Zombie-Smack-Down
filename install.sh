#!/usr/bin/env bash

zsd_path="$HOME/.zsd"
mkdir -p "$zsd_path/bin" > /dev/null
mkdir -p "$zsd_path/require" > /dev/null

curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/bin/ZSD -o "$zsd_path/bin/zsd"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/game.rb -o "$zsd_path/require/game.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/prefs.yaml -o "$zsd_path/require/prefs.yaml"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/update.sh -o "$zsd_path/update.sh"

chmod +x "$zsd_path/bin/ZSD"
chmod +x "$zsd_path/update.sh"

file1=`md5 -q $zsd_path/bin/ZSD 2> /dev/null`
file2=`md5 -q $zsd_path/require/game.rb 2> /dev/null`
file3=`md5 -q $zsd_path/require/prefs.yaml 2> /dev/null`

git1=`curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/bin/ZSD | md5`
git2=`curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/game.rb | md5`
git3=`curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/prefs.yaml | md5`

if ! cat ~/.bash_profile | grep -q "\$HOME/.zsd/bin" ; then
	echo 'export PATH="$HOME/.zsd/bin:$PATH"' >> ~/.bash_profile
	source ~/.bash_profile
fi

if [[ $file1 == $git1 ]] && [[ $file2 == $git2 ]] && [[ $file3 == $git3 ]]; then
	if [[ -x "$zsd_path/bin/ZSD" ]]; then
		if cat ~/.bash_profile | grep -q "\$HOME/.zsd/bin" ; then
			sudo curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/man/zsd.6 -o "/usr/share/man/man6/zsd.6"
			echo -e "\033[35mSuccess! Now enter ZSD to play Zombie Smack Down. You may have to open a new window for it to work.\033[39m"
		else
			echo "Installation Failed. Didn't add correct path to \$PATH"
		fi
	else
		echo "Installation failed. ZSD is not executable."
	fi
else
	echo "Installation failed. Files were not downloaded (correctly)."
fi
