#!/usr/bin/env bash

zsd_path="$HOME/.zsd"

curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/bin/ZSD -o "$zsd_path/bin/zsd"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/game.rb -o "$zsd_path/require/game.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/update.sh -o "$zsd_path/update.sh"

chmod +x "$zsd_path/bin/ZSD"
chmod +x "$zsd_path/update.sh"

file1=`md5 -q $zsd_path/bin/ZSD 2> /dev/null`
file2=`md5 -q $zsd_path/require/game.rb 2> /dev/null`

git1=`curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/bin/ZSD | md5`
git2=`curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/game.rb | md5`

if [[ $file1 == $git1 ]] && [[ $file2 == $git2 ]]; then
	if [[ -x "$zsd_path/bin/ZSD" ]]; then
		echo -e "\033[35mSuccess! Now enter ZSD to play Zombie Smack Down. You may have to open a new window for it to work.\033[39m"
	else
		echo "Installation failed. ZSD is not executable."
	fi
else
	echo "Installation failed. Files were not downloaded (correctly)."
fi
