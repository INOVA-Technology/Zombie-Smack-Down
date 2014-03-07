#!/usr/bin/env bash

zsd_path="$HOME/.zsd"

curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/zsd -o "$zsd_path/zsd"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/colors.rb -o "$zsd_path/require/colors.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/combo.rb -o "$zsd_path/require/combo.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/other.rb -o "$zsd_path/require/other.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/player.rb -o "$zsd_path/require/player.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/zombie.rb -o "$zsd_path/require/zombie.rb"
curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/update.sh -o "$zsd_path/update.sh"

chmod +x "$zsd_path/zsd"
chmod +x "$zsd_path/update.sh"
file1=`md5 -q $zsd_path/zsd 2> /dev/null`
file2=`md5 -q $zsd_path/require/colors.rb 2> /dev/null`
file3=`md5 -q $zsd_path/require/combo.rb 2> /dev/null`
file4=`md5 -q $zsd_path/require/other.rb 2> /dev/null`
file5=`md5 -q $zsd_path/require/player.rb 2> /dev/null`
file6=`md5 -q $zsd_path/require/zombie.rb 2> /dev/null`

git1=`curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/zsd | md5`
git2=`curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/colors.rb | md5`
git3=`curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/combo.rb | md5`
git4=`curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/other.rb | md5`
git5=`curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/player.rb | md5`
git6=`curl -s https://raw.github.com/INOVA-Technology/Zombie-Smack-Down/master/require/zombie.rb | md5`

if [[ $file1 == $git1 ]] && [[ $file2 == $git2 ]] && [[ $file3 == $git3 ]] && [[ $file4 == $git4 ]] && [[ $file5 == $git5 ]] && [[ $file6 == $git6 ]]; then
	if [[ -x "$zsd_path/zsd" ]]; then
		echo -e "\033[35mUpdate successful!\033[39m"
	else
		echo "Installation failed. ZSD is not executable."
	fi
else
	echo "Update failed. Files were not downloaded (correctly)."
fi
